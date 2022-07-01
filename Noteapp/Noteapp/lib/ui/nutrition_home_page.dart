import 'dart:convert';

import 'package:cs/db/my_database.dart';
import 'package:cs/extensions/extensions.dart';
import 'package:cs/model/food_model.dart';
import 'package:cs/model/nutrition_person_day_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../helper/app_shared.dart';
import '../helper/sync_data.dart';
import '../nutrition_app.dart';
import '../choose_activity_type.dart';
import '../server/service.dart';
import '../user_profile.dart';

class NutritionHomePage extends StatefulWidget {
  const NutritionHomePage({Key? key}) : super(key: key);

  @override
  _NutritionHomePageState createState() => _NutritionHomePageState();
}

class _NutritionHomePageState extends State<NutritionHomePage> {
  final List<Color> availableColors = const [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
    Colors.green
  ];

  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;
  int totalCaloLoss = 0;

  int totalKcal = 0;
  List<NutritionPersonDayModel> nutrition = [
    NutritionPersonDayModel("Calories", 0, 2000),
    NutritionPersonDayModel("Protein", 0, 158),
    NutritionPersonDayModel("Fat", 0, 578),
    NutritionPersonDayModel("Saturated Fat", 0, 123),
    NutritionPersonDayModel("Cholesterol", 0, 123),
    NutritionPersonDayModel("Potadium", 0, 234),
    NutritionPersonDayModel("Carbohydrat", 0, 456),
    NutritionPersonDayModel("Sodium", 0, 232),
    NutritionPersonDayModel("Diatery Fiber Sugar", 0, 2000),
    NutritionPersonDayModel("Vitamin A", 0, 2000),
    NutritionPersonDayModel("Vitamin C", 0, 2000),
    NutritionPersonDayModel("Iron", 0, 112),
    NutritionPersonDayModel("Gram", 0, 2450),
    NutritionPersonDayModel("Calcium", 0, 234),
    NutritionPersonDayModel("Transfat", 0, 432),
  ];

  double totalGramYesterday = 0;
  double totalGram2Ago = 0;
  double totalGram3Ago = 0;
  double totalGram4Ago = 0;
  double totalGram5Ago = 0;
  double totalGram6Ago = 0;
  double totalGram7Ago = 0;

  List<FoodModel> foodYesterday = [];
  List<FoodModel> food2Ago = [];
  List<FoodModel> food3Ago = [];
  List<FoodModel> food4Ago = [];
  List<FoodModel> food5Ago = [];
  List<FoodModel> food6Ago = [];
  List<FoodModel> food7Ago = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      getDataDefault();
      String strWarning = "";
      if (nutrition[0].value > 1000) {
        strWarning += "${nutrition[0].name} > 1000kcal";
      }
      if (nutrition[4].value > 500) {
        strWarning += "${nutrition[4].name} > 500 cholesterol";
      }
      if (nutrition[2].value > 500) {
        strWarning += "${nutrition[2].name} > 250";
      }
      if (strWarning.isNotEmpty) {
        AppShared.showMessage(strWarning);
      }
      try {
        SyncData.onSyncAct(context);
        SyncData.onSyncLocalData(context);
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          DateTime.now().lastDay(0),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.deepPurple[50],
                              borderRadius: BorderRadius.circular(8)),
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.pushNamed(context, PickFood.routeName)
                                  .then((value) {
                                _getData7DayAgo();
                                _getDataToday();
                                _getTotalCaloLoss();
                              });
                            },
                            color: purpleColor,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.deepPurple[50],
                              borderRadius: BorderRadius.circular(8)),
                          child: IconButton(
                            icon: Icon(Icons.supervised_user_circle),
                            onPressed: () {
                              Navigator.pushNamed(
                                      context, UserProfile.routeName)
                                  .then((value) {
                                _getData7DayAgo();
                                _getDataToday();
                                _getTotalCaloLoss();
                              });
                            },
                            color: purpleColor,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      height: 140,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                          color: purpleColor,
                          borderRadius: BorderRadius.circular(24)),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 4,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    top: 0,
                                    child: CircularPercentIndicator(
                                      radius: 120,
                                      lineWidth: 5.0,
                                      animation: true,
                                      percent: (totalKcal / 1000) > 1
                                          ? 1
                                          : totalKcal / 1000,
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Colors.white,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.2),
                                      center: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: purpleLightColor,
                                              shape: BoxShape.circle),
                                          padding: EdgeInsets.all(8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: purpleColor),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Total",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    "$totalKcal",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Text(
                                                  "kcal",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          const SizedBox(
                            width: 32,
                          ),
                          Expanded(
                              flex: 6,
                              child: ListView.builder(
                                  itemCount: nutrition.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nutrition[index].name,
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: LinearPercentIndicator(
                                              padding: EdgeInsets.zero,
                                              backgroundColor:
                                                  Colors.white.withOpacity(0.2),
                                              progressColor:
                                                  (nutrition[index].value /
                                                              nutrition[index]
                                                                  .limit) >
                                                          1.0
                                                      ? Colors.red
                                                      : Colors.white,
                                              percent: (nutrition[index].value /
                                                          nutrition[index]
                                                              .limit) >
                                                      1.0
                                                  ? 1
                                                  : nutrition[index].value /
                                                      nutrition[index].limit,
                                            ),
                                          ),
                                          Text(
                                            "${nutrition[index].value} / ${nutrition[index].limit}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ))),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        color: const Color(0xff81e5cd),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  const Text(
                                    'Nutrition chart',
                                    style: TextStyle(
                                        color: Color(0xff0f4a3c),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const Text(
                                    '7 days ago',
                                    style: TextStyle(
                                        color: Color(0xff379982),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 38,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: BarChart(
                                        mainBarData(),
                                        swapAnimationDuration: animDuration,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle, color: Colors.grey.shade300),
                    child: Text(
                      "Calo Loss",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Burned",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        "🔥",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  LinearPercentIndicator(
                                    padding: EdgeInsets.zero,
                                    backgroundColor:
                                        Colors.red.withOpacity(0.2),
                                    progressColor: Colors.red,
                                    percent: totalCaloLoss / 3000,
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${totalCaloLoss} kcal",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                  flex: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getDataToday() async {
    totalKcal = 0;
    (await DatabaseHelper.instance.getFoodByDate(DateTime.now().lastDay(0)))
        .forEach((food) {
      totalKcal += double.tryParse(food.calories ?? "0")?.toInt() ?? double.tryParse(food.calories ?? "0")?.toInt() ??
          0;
      nutrition.forEach((element) {
        if (element.name == "Calories") {
          element.value += int.tryParse(food.calories ?? "0")?.toInt() ??
              double.tryParse(food.calories ?? "0")?.toInt() ??
              0;
        } else if (element.name == "Protein") {
          element.value += int.tryParse(food.protein ?? "0")?.toInt() ??
              double.tryParse(food.protein ?? "0")?.toInt() ??
              0;
        } else if (element.name == "Fat") {
          element.value += int.tryParse(food.fat ?? "0")?.toInt() ??
              double.tryParse(food.fat ?? "0")?.toInt() ??
              0;
        } else if (element.name == "Saturated Fat") {
          element.value += int.tryParse(food.saturated_fat ?? "0")?.toInt() ??
              double.tryParse(food.saturated_fat ?? "0")?.toInt() ??
              0;
        } else if (element.name == "Cholesterol") {
          element.value += int.tryParse(food.cholesterol ?? "0")?.toInt() ??
              double.tryParse(food.cholesterol ?? "0")?.toInt() ??
              0;
        } else if (element.name == "Potadium") {
          element.value += int.tryParse(food.potassium ?? "0")?.toInt() ??
              double.tryParse(food.potassium ?? "0")?.toInt() ??
              0;
        } else if (element.name == "Carbohydrat") {
          element.value += int.tryParse(food.carbohydrates ?? "0")?.toInt() ??
              double.tryParse(food.carbohydrates ?? "0")?.toInt() ??
              0;
        } else if (element.name == "Sodium") {
          element.value += int.tryParse(food.sodium ?? "0")?.toInt() ??
              double.tryParse(food.sodium ?? "0")?.toInt() ??
              0;
        } else if (element.name == "Diatery Fiber Sugar") {
          element.value += int.tryParse(food.diatery_fiber_sugar ?? "0")?.toInt() ??
              double.tryParse(food.diatery_fiber_sugar ?? "0")?.toInt() ??
              0;
        } else if (element.name == "Vitamin A") {
          element.value += int.tryParse(food.vitamin_a ?? "0")?.toInt() ??
              double.tryParse(food.vitamin_a ?? "0")?.toInt() ??
              0;
        } else if (element.name == "Vitamin C") {
          element.value += int.tryParse(food.vitamin_c ?? "0")?.toInt() ??
              double.tryParse(food.vitamin_c ?? "0")?.toInt() ??
              0;
        } else if (element.name == "Iron") {
          element.value += int.tryParse(food.iron ?? "0")?.toInt() ??
              double.tryParse(food.iron ?? "0")?.toInt() ??
              0;
        } else if (element.name == "Gram") {
          element.value += int.tryParse(food.meal_volume ?? "0")?.toInt() ??
              double.tryParse(food.meal_volume ?? "0")?.toInt() ??
              0;
        } else if (element.name == "Calcium") {
          element.value += int.tryParse(food.calcium ?? "0")?.toInt() ??
              double.tryParse(food.calcium ?? "0")?.toInt() ??
              0;
        } else if (element.name == "Transfat") {
          element.value += int.tryParse(food.trans_fat ?? "0")?.toInt() ??
              double.tryParse(food.trans_fat ?? "0")?.toInt() ??
              0;
        }
      });
    });
    setState(() {});
  }

  _getData7DayAgo() async {
    (await DatabaseHelper.instance.getFoodByDate(DateTime.now().lastDay(1)))
        .forEach((value) {
      totalGramYesterday += double.tryParse(value.meal_volume ?? "0") ?? 0;
      foodYesterday.add(value);
    });

    (await DatabaseHelper.instance.getFoodByDate(DateTime.now().lastDay(2)))
        .forEach((value) {
      totalGram2Ago += double.tryParse(value.meal_volume ?? "0") ?? 0;
      food2Ago.add(value);
    });

    (await DatabaseHelper.instance.getFoodByDate(DateTime.now().lastDay(3)))
        .forEach((value) {
      totalGram3Ago += double.tryParse(value.meal_volume ?? "0") ?? 0;
      food3Ago.add(value);
    });

    (await DatabaseHelper.instance.getFoodByDate(DateTime.now().lastDay(4)))
        .forEach((value) {
      totalGram4Ago += double.tryParse(value.meal_volume ?? "0") ?? 0;
      food4Ago.add(value);
    });

    (await DatabaseHelper.instance.getFoodByDate(DateTime.now().lastDay(5)))
        .forEach((value) {
      totalGram5Ago += double.tryParse(value.meal_volume ?? "0") ?? 0;
      food5Ago.add(value);
    });

    (await DatabaseHelper.instance.getFoodByDate(DateTime.now().lastDay(6)))
        .forEach((value) {
      totalGram6Ago += double.tryParse(value.meal_volume ?? "0") ?? 0;
      food6Ago.add(value);
    });

    (await DatabaseHelper.instance.getFoodByDate(DateTime.now().lastDay(7)))
        .forEach((value) {
      totalGram7Ago += double.tryParse(value.meal_volume ?? "0") ?? 0;
      food7Ago.add(value);
    });
    setState(() {});
  }

  _getTotalCaloLoss() async {
    totalCaloLoss = 0;
    (await DatabaseHelper.instance.getAllActivities()).forEach((element) {
      var date1 = element.date?.replaceFirst("T", " ");
      if (date1 != null && date1.split(" ")[0] == DateTime.now().lastDay(0)) {
        totalCaloLoss += int.tryParse(element.caloLos ?? "0") ?? 0;
      }
    });
  }

  getDataDefault() async {
    AppShared.showLoading(context);
    await Future.wait<void>([
      _getData7DayAgo(),
      _getDataToday(),
      _getTotalCaloLoss(),
      getFood(),
      getActivity(),
      getGroup(),
    ]).catchError((onError) {
      AppShared.hideLoading(context);
    });
    AppShared.hideLoading(context);
  }

  getFood() async {
    var listFood = await DatabaseHelper.instance.getAllFoodSearch();
    if (listFood.isEmpty) {
      var res = await Service()
          .call
          ?.get("api/nutritionfact/search?size=1000")
          .catchError((onError) {
        print(onError.toString());
        AppShared.showMessage(onError.response.data["message"], isRed: true);
      });
      if (res?.statusCode == 200) {
        (res?.data as List<dynamic>?)?.forEach((item) {
          DatabaseHelper.instance.insertFoodSearch({
            DatabaseHelper.columnIdActivity: item["food"]["id"].toString(),
            DatabaseHelper.columnName: item["food"]["name"],
            DatabaseHelper.colImage: item["food"]["image"],
            DatabaseHelper.colscope: item["food"]["scope"],
            DatabaseHelper.colGroupID: item["food"]["foodGroup"]["id"],
            DatabaseHelper.colGroupName: item["food"]["foodGroup"]
                ["group_name"],
            DatabaseHelper.colIsIngredient: item["is_ingredient"],
            //
            DatabaseHelper.columnProtein: item["protein"],
            DatabaseHelper.columnFat: item["fat"],
            DatabaseHelper.columnSaturatedFat: item["saturated_fat"],
            DatabaseHelper.columnCholesterol: item["cholesterol"],
            DatabaseHelper.columnCalories: item["calories"],
            DatabaseHelper.columnPotadium: item["potassium"],
            DatabaseHelper.columnCarbohydrat: item["carbohydrates"],
            DatabaseHelper.columnSodium: item["sodium"],
            DatabaseHelper.columnDiateryFiberSugar: item["diatery_fiber"],
            DatabaseHelper.columnVitaminA: item["vitamin_a"],
            DatabaseHelper.columnVitaminC: item["vitamin_c"],
            DatabaseHelper.columnIron: item["iron"],
            DatabaseHelper.columnGram: item["serving_weight_grams"],
            DatabaseHelper.columnMealDate: item["is_ingredient"],
            DatabaseHelper.columnCalcium: item["calcium"],
            DatabaseHelper.columnTransFat: item["trans_fat"],
          });
        });
      }
    }
  }

  getActivity() async {
    var listAct = await DatabaseHelper.instance.getAllActSearch();
    if (listAct.isEmpty) {
      var res = await Service().call?.get("api/listactivities/search");
      if (res?.statusCode == 200) {
        (res?.data["content"] as List<dynamic>?)?.forEach((element) {
          DatabaseHelper.instance.insertActSearch({
            DatabaseHelper.columnIdActivity: element["id"].toString(),
            DatabaseHelper.columnName: element["name"],
            DatabaseHelper.colCaloPerHour: element["calo_per_hour"],
          });
        });
      }
    }
  }

  getGroup() async {
    var listAct = await DatabaseHelper.instance.getAllGroupSearch();
    if (listAct.isEmpty) {
      var res = await Service().call?.get("api/foodgroup/search");
      if (res?.statusCode == 200) {
        (res?.data as List<dynamic>?)?.forEach((element) {
          DatabaseHelper.instance.insertGroup({
            DatabaseHelper.columnIdActivity: element["id"].toString(),
            DatabaseHelper.colGroupName: element["group_name"],
          });
        });
      }
    }
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.yellow.darken(), width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, totalGram7Ago,
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, totalGram6Ago,
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, totalGram5Ago,
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, totalGram4Ago,
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, totalGram3Ago,
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, totalGram2Ago,
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, totalGramYesterday,
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              List<FoodModel> foods;
              String weekDay = '';
              switch (group.x.toInt()) {
                case 0:
                  weekDay = DateTime.now().lastDay(7);
                  foods = food7Ago;
                  break;
                case 1:
                  weekDay = DateTime.now().lastDay(6);
                  foods = food6Ago;
                  break;
                case 2:
                  weekDay = DateTime.now().lastDay(5);
                  foods = food5Ago;
                  break;
                case 3:
                  weekDay = DateTime.now().lastDay(4);
                  foods = food4Ago;
                  break;
                case 4:
                  weekDay = DateTime.now().lastDay(3);
                  foods = food3Ago;
                  break;
                case 5:
                  weekDay = DateTime.now().lastDay(2);
                  foods = food2Ago;
                  break;
                case 6:
                  weekDay = DateTime.now().lastDay(1);
                  foods = foodYesterday;
                  break;
                default:
                  throw Error();
              }

              return BarTooltipItem(
                weekDay + '\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: "Calories: ",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: foods.getCalo(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: "\nProtein: ",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: foods.getPro(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              );
            }),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(DateTime.now().lastDay(7, format: "MM-dd"), style: style);
        break;
      case 1:
        text = Text(DateTime.now().lastDay(6, format: "MM-dd"), style: style);
        break;
      case 2:
        text = Text(DateTime.now().lastDay(5, format: "MM-dd"), style: style);
        break;
      case 3:
        text = Text(DateTime.now().lastDay(4, format: "MM-dd"), style: style);
        break;
      case 4:
        text = Text(DateTime.now().lastDay(3, format: "MM-dd"), style: style);
        break;
      case 5:
        text = Text(DateTime.now().lastDay(2, format: "MM-dd"), style: style);
        break;
      case 6:
        text = Text(DateTime.now().lastDay(1, format: "MM-dd"), style: style);
        break;
      case 6:
        text = Text(DateTime.now().lastDay(0, format: "MM-dd"), style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}
