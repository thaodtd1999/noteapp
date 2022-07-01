import '../db/my_database.dart';
import 'food_group_model.dart';

class FoodSearchModel {
  FoodSearchModel({
    this.id,
    this.name,
    this.image,
    this.language,
    this.owner,
    this.scope,
    this.createdAt,
    this.updatedAt,
    this.isIngredient,
    this.foodGroup,
    this.isNewFood,
    this.calories,
    this.fat,
    this.saturated_fat,
    this.trans_fat,
    this.protein,
    this.cholesterol,
    this.sodium,
    this.potassium,
    this.carbohydrates,
    this.diatery_fiber_sugar,
    this.vitamin_a,
    this.vitamin_c,
    this.meal_volume,
    this.calcium,
    this.iron,
  });

  FoodSearchModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    language = json['language'];
    owner = json['owner'];
    scope = json['scope'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isIngredient = json['is_ingredient'];
    foodGroup = json['foodGroup'] != null
        ? FoodGroup.fromJson(json['foodGroup'])
        : null;
  }

  FoodSearchModel.fromSQLJson(dynamic json) {
    id = json[DatabaseHelper.columnIdActivity];
    name = json[DatabaseHelper.columnNameActivity];
    image = json[DatabaseHelper.colImage];
    scope = json[DatabaseHelper.colscope];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isIngredient = json[DatabaseHelper.colIsIngredient];
    foodGroup = FoodGroup(
        id: int.parse(json[DatabaseHelper.colGroupID]),
        groupName: json[DatabaseHelper.colGroupName]);
    calories = json[DatabaseHelper.columnCalories];
    calcium = json[DatabaseHelper.columnCalcium];
    carbohydrates = json[DatabaseHelper.columnCarbohydrat];
    cholesterol = json[DatabaseHelper.columnCholesterol];
    diatery_fiber_sugar = json[DatabaseHelper.columnDiateryFiberSugar];
    fat = json[DatabaseHelper.columnFat];
    vitamin_c = json[DatabaseHelper.columnVitaminC];
    vitamin_a = json[DatabaseHelper.columnVitaminA];
    meal_volume = json[DatabaseHelper.columnGram];
    potassium = json[DatabaseHelper.columnPotadium];
    saturated_fat = json[DatabaseHelper.columnSaturatedFat];
    trans_fat = json[DatabaseHelper.columnTransFat];
    protein = json[DatabaseHelper.columnProtein];
    iron = json[DatabaseHelper.columnProtein];
    sodium = json[DatabaseHelper.columnSodium];
  }

  int? id;
  String? name;
  String? image;
  String? language;
  dynamic owner;
  String? scope;
  String? createdAt;
  dynamic updatedAt;
  String? isIngredient;
  FoodGroup? foodGroup;
  bool? isNewFood;
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

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['language'] = language;
    map['owner'] = owner;
    map['scope'] = scope;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['is_ingredient'] = isIngredient;
    if (foodGroup != null) {
      map['foodGroup'] = foodGroup?.toJson();
    }
    return map;
  }
}
