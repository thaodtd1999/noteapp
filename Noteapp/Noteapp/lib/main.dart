import 'package:cs/choose_activity_type.dart';
import 'package:cs/db/my_database.dart';
import 'package:cs/helper/app_shared.dart';
import 'package:cs/helper/spref.dart';
import 'package:cs/login.dart';
import 'package:cs/add_food.dart';
import 'package:cs/nutrition_app.dart';
import 'package:cs/sign_up.dart';
import 'package:cs/ui/meal/food/list_food_widget.dart';
import 'package:cs/ui/meal/list_meal_widget.dart';
import 'package:cs/user_profile.dart';
import 'package:flutter/material.dart';
import 'server/service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper.instance.database;
  await SPref().init();
  Service().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: AppShared.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginPage.routeName,
      routes: <String, WidgetBuilder>{
        LoginPage.routeName: (context) => LoginPage(),
        NutritionApp.routeName: (context) => NutritionApp(),
        PickFood.routeName: (context) => PickFood(),
        ListMealWidget.routeName: (context) => ListMealWidget(),
        ListFoodWidget.routeName: (context) => ListFoodWidget(),
        AddFood.routeName: (context) => AddFood(),
        UserProfile.routeName: (context) => UserProfile(),
        SignUpPage.routeName: (context) => SignUpPage()
      },
    );
  }
}
