import 'package:cs/add_food.dart';
import 'package:cs/nutrition_app.dart';
import 'package:cs/ui/meal/list_meal_widget.dart';
import 'package:flutter/material.dart';

import 'others_activities.dart';

class PickFood extends StatefulWidget {
  static var routeName = "/pick_food";

  const PickFood({Key? key}) : super(key: key);

  @override
  _PickFoodState createState() => _PickFoodState();
}

class _PickFoodState extends State<PickFood> {
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Note activities';
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: const MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 16,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: MaterialButton(
                elevation: 100,
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
                onPressed: () {
                  Navigator.pushNamed(context, ListMealWidget.routeName);
                },
                child: Text(
                  'Meals',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: MaterialButton(
                elevation: 100,
                color: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OthersActivities()));
                },
                child: Text(
                  'Other activities',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}