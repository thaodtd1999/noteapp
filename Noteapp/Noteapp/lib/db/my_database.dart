import 'package:cs/model/activity_model.dart';
import 'package:cs/model/food_group_model.dart';
import 'package:cs/model/food_model.dart';
import 'package:cs/model/food_search_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/activity_search_model.dart';

class DatabaseHelper {
  static final _databaseName = "MyFood.db";
  static final _databaseVersion = 3;
  static final table = 'Food';
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnProtein = 'protein';
  static final columnFat = 'fat';
  static final columnSaturatedFat = 'saturated_fat';
  static final columnCholesterol = 'cholesterol';
  static final columnCalories = 'calories';
  static final columnMealType = 'meal_id';
  static final columnPotadium = 'potassium';
  static final columnCarbohydrat = 'carbohydrates';
  static final columnSodium = 'sodium';
  static final columnDiateryFiberSugar = 'diatery_fiber';
  static final columnVitaminA = 'vitamin_a';
  static final columnVitaminC = 'vitamin_c';
  static final columnIron = 'iron';
  static final columnGram = 'serving_weight_grams';
  static final columnMealDate = 'date';
  static final columnCalcium = 'calcium';
  static final columnTransFat = 'trans_fat';
  static final columnSync = 'sync';
  static final columnType = 'type';
  static final columnCreateAt = 'create_at';
  static final columnForSearch = 'for_search';

  static final tableActivity = 'Activity';
  static final columnIdActivity = 'id';
  static final columnNameActivity = 'name';
  static final columnDateActivity = 'date';
  static final columnCaloLess = 'calo';
  static final columnDurationActivity = 'duration';

  static final tableFood = "FoodSearch";
  static final colImage = "image";
  static final colscope = "scope";
  static final colIsIngredient = "omgredient";
  static final colGroupID = "group_id";
  static final colGroupName = "group_name";

  static final tableActivitySearch = "ActivitySeach";
  static final colCaloPerHour = "calo_per_house";

  static final tableGroup = "group_food";

// make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

// only have a single app-wide reference to the database
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

// this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpdate);
  }

// SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    var str = "CREATE TABLE $table ($columnId INTEGER PRIMARY KEY,"
        "$columnName TEXT,$columnProtein TEXT"
        ", $columnFat TEXT,$columnSaturatedFat TEXT,$columnCholesterol TEXT, $columnCalories TEXT, $columnMealType TEXT"
        ", $columnPotadium TEXT, $columnCarbohydrat TEXT, $columnSodium TEXT"
        ", $columnDiateryFiberSugar TEXT, $columnVitaminA TEXT, $columnVitaminC TEXT, $columnIron TEXT"
        ", $columnGram TEXT, $columnMealDate TEXT, $columnCalcium TEXT, $columnTransFat TEXT, $columnSync INTEGER, $columnType TEXT, $columnCreateAt TEXT, $columnForSearch TEXT)";
    await db.execute(str);
    var strActivity =
        "CREATE TABLE $tableActivity ($columnIdActivity INTEGER PRIMARY KEY,"
        "$columnNameActivity TEXT,$columnDurationActivity TEXT,"
        "$columnDateActivity TEXT, $columnCaloLess TEXT, $columnSync INTEGER)";
    await db.execute(strActivity);

    var strFoodSearch =
        "CREATE TABLE $tableFood ($columnIdActivity INTEGER PRIMARY KEY,"
        "$columnNameActivity TEXT,$colGroupID TEXT,"
        "$colGroupName TEXT, $colIsIngredient TEXT, $colImage TEXT, $colscope TEXT,$columnProtein TEXT"
        ", $columnFat TEXT,$columnSaturatedFat TEXT,$columnCholesterol TEXT, $columnCalories TEXT, $columnMealType TEXT"
        ", $columnPotadium TEXT, $columnCarbohydrat TEXT, $columnSodium TEXT"
        ", $columnDiateryFiberSugar TEXT, $columnVitaminA TEXT, $columnVitaminC TEXT, $columnIron TEXT"
        ", $columnGram TEXT, $columnMealDate TEXT, $columnCalcium TEXT, $columnTransFat TEXT)";
    await db.execute(strFoodSearch);

    var strActSearch =
        "CREATE TABLE $tableActivitySearch ($columnIdActivity INTEGER PRIMARY KEY,"
        "$columnNameActivity TEXT,$colCaloPerHour TEXT, $columnForSearch INTEGER)";
    await db.execute(strActSearch);

    var group =
        "CREATE TABLE $tableGroup ($columnIdActivity INTEGER PRIMARY KEY, $colGroupName TEXT)";
    await db.execute(group);
  }

  Future _onUpdate(Database db, int oldVersion, int version) async {
    var srt = [
      "drop table $table",
      "drop table $tableActivity",
      "drop table $tableFood",
      "drop table $tableActivitySearch",
      "drop table $tableGroup",
    ];
    srt.forEach((element) async {
      await db.execute(element);
    });
    _onCreate(db, version);
  }

  Future<int?> insertFood(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(table, row);
  }

  Future<List<FoodModel>> getFoodByMeal(String? id, String date) async {
    List<FoodModel> data = [];
    Database? db = await instance.database;
    await db?.query(table, where: '$columnMealType = ?', whereArgs: [id]).then(
        (value) {
      value.forEach((element) {
        var item = FoodModel.fromJson(element);
        if (item.date?.split("T")[0] == date) {
          data.add(item);
        }
      });
    });
    return data;
  }

  Future<List<FoodModel>> getFoodByDate(String date) async {
    List<FoodModel> data = [];
    Database? db = await instance.database;
    await db?.query(table).then((value) {
      value.forEach((element) {
        var item = FoodModel.fromJson(element);
        var date1 = item.date?.split(" ");
        if ((date1?.length ?? 0) > 1) {
          if (date1![0] == date) {
            data.add(item);
          }
        } else {
          if (item.date?.replaceFirst("T", " ").split(" ")[0] == date) {
            data.add(item);
          }
        }
      });
    });
    return data;
  }

  Future<List<FoodModel>> getAllFood() async {
    List<FoodModel> data = [];
    Database? db = await instance.database;
    await db
        ?.query(
      table,
    )
        .then((value) {
      value.forEach((element) {
        print(FoodModel.fromJson(element).toString());
        data.add(FoodModel.fromJson(element));
      });
    });
    return data;
  }

  Future<int?> insertActivity(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(tableActivity, row);
  }

  Future<int?> updateFood(int id, int value) async {
    Database? db = await instance.database;
    return await db?.rawUpdate("'UPDATE $table SET $columnSync = $value WHERE $columnId = $id");
  }

  Future<List<ActivityModel>> getAllActivities() async {
    List<ActivityModel> data = [];
    Database? db = await instance.database;
    await db
        ?.query(
      tableActivity,
    )
        .then((value) {
      value.forEach((element) {
        data.add(ActivityModel.fromJson(element));
      });
    });
    return data;
  }

  Future<int?> updateAct(int id, int value) async {
    Database? db = await instance.database;
    return await db?.rawUpdate("'UPDATE $tableActivity SET $columnSync = $value WHERE $columnId = $id");
  }

  Future<List<FoodSearchModel>> getAllFoodSearch() async {
    List<FoodSearchModel> data = [];
    Database? db = await instance.database;
    await db
        ?.query(
      tableFood,
    )
        .then((value) {
      value.forEach((element) {
        data.add(FoodSearchModel.fromSQLJson(element));
      });
    }).catchError((onError) {
      print(onError);
    });
    return data;
  }

  Future<int?> insertFoodSearch(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(tableFood, row);
  }

  Future<List<ActivitySearchModel>> getAllActSearch() async {
    List<ActivitySearchModel> data = [];
    Database? db = await instance.database;
    await db
        ?.query(
      tableActivitySearch,
    )
        .then((value) {
      value.forEach((element) {
        data.add(ActivitySearchModel.fromSQLJson(element));
      });
    });
    return data;
  }

  Future<int?> insertActSearch(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(tableActivitySearch, row);
  }

  Future<List<FoodGroup>> getAllGroupSearch() async {
    List<FoodGroup> data = [];
    Database? db = await instance.database;
    await db
        ?.query(
      tableGroup,
    )
        .then((value) {
      value.forEach((element) {
        data.add(FoodGroup.fromJson(element));
      });
    });
    return data;
  }

  Future<int?> insertGroup(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(tableGroup, row);
  }
}
