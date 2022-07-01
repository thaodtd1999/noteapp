import 'dart:core';

import 'package:cs/db/my_database.dart';

class FoodModel {
  int id;
  String? name;
  String? calories;
  String? fat;
  String? saturated_fat;
  String? trans_fat;
  String? protein;
  String? cholesterol;
  String? sodium;
  String? potassium;
  String? carbohydrates;
  String? diatery_fiber_sugar;
  String? vitamin_a;
  String? vitamin_c;
  String? calcium;
  String? iron;
  String? meal_volume;
  String? date;
  String? mealId;
  bool? isSync;
  String? type;
  String? create_at;
  bool? isDefault;
  int? groupID;
  String? groupName;

  FoodModel(
      {required this.id, this.name, this.calories, this.fat, this.saturated_fat,
        this.trans_fat, this.protein, this.cholesterol, this.sodium,
        this.potassium, this.carbohydrates, this.diatery_fiber_sugar,
        this.vitamin_a, this.date, this.vitamin_c, this.groupID, this.groupName, this.mealId, this.calcium, this.type, this.isDefault, this.create_at, this.iron, this.meal_volume, this.isSync});

  static FoodModel fromJson(Map<String, dynamic> json) =>
      FoodModel(
        id: json[DatabaseHelper.columnId],
        name: json[DatabaseHelper.columnName],
        calories: json[DatabaseHelper.columnCalories],
        calcium: json[DatabaseHelper.columnCalcium],
        carbohydrates: json[DatabaseHelper.columnCarbohydrat],
        cholesterol: json[DatabaseHelper.columnCholesterol],
        diatery_fiber_sugar: json[DatabaseHelper.columnDiateryFiberSugar],
        fat: json[DatabaseHelper.columnFat],
        vitamin_c: json[DatabaseHelper.columnVitaminC],
        vitamin_a: json[DatabaseHelper.columnVitaminA],
        meal_volume: json[DatabaseHelper.columnGram],
        potassium: json[DatabaseHelper.columnPotadium],
        saturated_fat: json[DatabaseHelper.columnSaturatedFat],
        trans_fat: json[DatabaseHelper.columnTransFat],
        date: json[DatabaseHelper.columnMealDate],
        mealId: json[DatabaseHelper.columnMealType],
        protein: json[DatabaseHelper.columnProtein],
        iron: json[DatabaseHelper.columnProtein],
        sodium: json[DatabaseHelper.columnSodium],
        isSync: json[DatabaseHelper.columnSync] == 1,
        type: json[DatabaseHelper.columnType],
        create_at: json[DatabaseHelper.columnCreateAt],
      );

  Map<String, dynamic> toJson() {
    return {
      DatabaseHelper.columnId: id,
      DatabaseHelper.columnName: name,
      DatabaseHelper.columnCalories: calories,
      DatabaseHelper.columnCalcium: calcium,
      DatabaseHelper.columnCarbohydrat: carbohydrates,
      DatabaseHelper.columnCholesterol: cholesterol,
      DatabaseHelper.columnDiateryFiberSugar: diatery_fiber_sugar,
      DatabaseHelper.columnFat: fat,
      DatabaseHelper.columnVitaminC: vitamin_c,
      DatabaseHelper.columnVitaminA: vitamin_a,
      DatabaseHelper.columnGram: meal_volume,
      DatabaseHelper.columnPotadium: potassium,
      DatabaseHelper.columnSaturatedFat: saturated_fat,
      DatabaseHelper.columnTransFat: trans_fat,
      DatabaseHelper.columnMealDate: date,
      DatabaseHelper.columnMealType: mealId,
      DatabaseHelper.columnProtein: protein,
      DatabaseHelper.columnProtein: iron,
      DatabaseHelper.columnSodium: sodium,
      DatabaseHelper.columnSync: isSync == true ? 1 : 0,
      DatabaseHelper.columnType: type,
      DatabaseHelper.columnCreateAt: create_at,
    };
  }
}
