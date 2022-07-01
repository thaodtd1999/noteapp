import 'package:cs/ui/nutrition_home_page.dart';
import 'package:flutter/material.dart';


Color purpleColor = Color(0xff655fb1);
Color purpleLightColor = Color(0xff6e69b6);

class NutritionApp extends StatelessWidget {
  static var routeName = "/home";

  const NutritionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NutritionHomePage();
  }
}
