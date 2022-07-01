import 'package:cs/db/my_database.dart';
import 'package:cs/add_food.dart';
import 'package:cs/model/food_model.dart';
import 'package:cs/model/meal_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListFoodWidget extends StatefulWidget {
  static var routeName = "/list_food";

  @override
  State<StatefulWidget> createState() {
    return _ListFoodState();
  }
}

class _ListFoodState extends State<ListFoodWidget> {
  List<FoodModel> foods = [];
  late MealModel meal;
  late String date;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _getData();
  }

  _getData() {
    var argument = (ModalRoute.of(context)!.settings.arguments
    as Map<String, dynamic>);
    date = argument["date"];
    meal = argument["meal"];

    foods.clear();
    DatabaseHelper.instance
        .getFoodByMeal(meal.type, date)
        .then((value) => {
      setState(() => foods.addAll(value))
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name.toString()),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  return itemView(foods[index]);
                }),
            flex: 1,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, AddFood.routeName, arguments: {
                "meal": meal,
                "date": date
              }).then((value) => _getData());
            },
            child: Text("+"),
          )
        ],
      ),
    );
  }

  Widget itemView(FoodModel item) {
    return Card(
      child: Container(
          height: 40,
          alignment: Alignment.center,
          child: Text(item.name ?? "")),
    );
  }
}
