import 'package:cs/model/meal_model.dart';

class DataCore {

  static List<MealModel> dataMeal = [
    MealModel(id: 1, name: "Breakfast", type: "bữa sáng", createAt: "7h"),
    MealModel(id: 2, name: "Lunch", type: "bữa trưa", createAt: "12h"),
    MealModel(id: 3, name: "Dinner", type: "bữa tối", createAt: "19h"),
    MealModel(id: 4, name: "Snack", type: "bữa snack", createAt: "21h")
  ];
}