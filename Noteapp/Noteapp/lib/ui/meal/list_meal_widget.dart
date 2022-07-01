import 'package:cs/data/data_core.dart';
import 'package:cs/extensions/extensions.dart';
import 'package:cs/model/meal_model.dart';
import 'package:cs/ui/meal/food/list_food_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListMealWidget extends StatefulWidget {
  static var routeName = "/list_meal";

  ListMealWidget();

  @override
  State<StatefulWidget> createState() {
    return _ListMealState();
  }
}

class _ListMealState extends State<ListMealWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today"),
      ),
      body: ListView.builder(
          itemCount: DataCore.dataMeal.length,
          itemBuilder: (context, index) {
            return itemView(DataCore.dataMeal[index]);
          }),
    );
  }

  Widget itemView(MealModel item) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ListFoodWidget.routeName, arguments: {
          "meal": item,
          "date": DateTime.now().convertToString()
        });
      },
      child: Card(
        child: Container(
            height: 40, alignment: Alignment.center, child: Text(item.name)),
      ),
    );
  }
}
