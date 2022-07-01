import 'dart:convert';
import 'dart:math';

import 'package:cs/db/my_database.dart';
import 'package:cs/helper/spref.dart';
import 'package:cs/model/food_group_model.dart';
import 'package:cs/model/food_model.dart';
import 'package:cs/model/food_search_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';

import 'helper/app_shared.dart';
import 'login.dart';
import 'model/meal_model.dart';
import 'server/service.dart';

class AddFood extends StatefulWidget {
  static var routeName = "/add_food";

  const AddFood({Key? key}) : super(key: key);

  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  late MealModel meal;
  late String date;
  FoodModel foodModel = FoodModel(
      id: DateTime.now().millisecondsSinceEpoch,
      mealId: "0",
      date: "0",
      isDefault: false);
  List<FoodSearchModel> foods = [];
  List<FoodGroup> groups = [];
  FoodGroup? foodGroup;
  bool isDefault = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      var argument =
          (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>);
      var dateTime = DateTime.now();
      date =
          "${argument["date"]}T${dateTime.hour < 10 ? "0${dateTime.hour}" : dateTime.hour}:${dateTime.minute < 10 ? "0${dateTime.minute}" : dateTime.minute}:${dateTime.second < 10 ? "0${dateTime.second}" : dateTime.second}.${dateTime.millisecond}+00:00";
      meal = argument["meal"];
      foodModel.date = date;
      foodModel.mealId = meal.id.toString();
      //AppShared.showLoading(context);
      var foodTemp = await DatabaseHelper.instance.getAllFoodSearch();
      foods = foodTemp;
      var acts = await DatabaseHelper.instance.getAllFood();
      acts.forEach((element) {
        foods.add(FoodSearchModel(
          id: 1,
          name: element.name,
        ));
      });
      var groupsTemp = await DatabaseHelper.instance.getAllGroupSearch();
      groups = groupsTemp;
      foodGroup = groups[0];
      //AppShared.hideLoading(context);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Note food for meal';
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: view(),
    );
  }

  Widget view() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text("Tìm kiếm"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Autocomplete<FoodSearchModel>(
              displayStringForOption: (FoodSearchModel eq) {
                return eq.name.toString();
              },
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<FoodSearchModel>.empty();
                }
                return foods.where((FoodSearchModel option) {
                  return option.name
                      .toString()
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (FoodSearchModel eq) async {
                setState(() {
                  foodModel = FoodModel(
                    id: eq.id ?? 0,
                    name: eq.name ?? "",
                    isDefault: eq.isNewFood != true,
                    groupID: eq.foodGroup?.id,
                    groupName: eq.foodGroup?.groupName,
                    trans_fat: eq.trans_fat,
                    protein: eq.protein,
                    saturated_fat: eq.saturated_fat,
                    cholesterol: eq.cholesterol,
                    carbohydrates: eq.carbohydrates,
                    calcium: eq.calcium,
                    iron: eq.iron,
                    vitamin_c: eq.vitamin_c,
                    vitamin_a: eq.vitamin_a,
                    diatery_fiber_sugar: eq.diatery_fiber_sugar,
                    sodium: eq.sodium,
                    potassium: eq.potassium,
                    calories: eq.calories,
                    fat: eq.fat,
                  );
                  isDefault = foodModel.isDefault ?? false;
                });
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: TextEditingController(text: foodModel.name ?? ""),
              readOnly: isDefault,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Food name',
              ),
              onChanged: (text) {
                foodModel.name = text;
                isDefault = false;
              },
            ),
          ),
          DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            dateMask: 'd MMM, yyyy',
            initialValue: foodModel.date?.isNotEmpty == true
                ? foodModel.date
                : DateTime.now().toString(),
            firstDate: DateTime(2022),
            lastDate: DateTime(2100),
            icon: Icon(Icons.event),
            dateLabelText: 'Date',
            timeLabelText: "Hour",
            selectableDayPredicate: (date) {
              // Disable weekend days to select from the calendar
              if (date.weekday == 6 || date.weekday == 7) {
                return false;
              }
              return true;
            },
            onChanged: (val) => foodModel.date = val,
            validator: (val) {
              return null;
            },
            onSaved: (val) => print(val),
          ),
          Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Text(
                  "Food Group",
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: viewChooseGroup(),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: TextEditingController(
                      text: foodModel.carbohydrates ?? ""),
                  readOnly: isDefault,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Carbs(gram)',
                  ),
                  onChanged: (text) {
                    foodModel.carbohydrates = text;
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                    controller:
                        TextEditingController(text: foodModel.calcium ?? ""),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    readOnly: isDefault,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Calcium(gram)',
                    ),
                    onChanged: (text) {
                      foodModel.calcium = text;
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                    controller:
                        TextEditingController(text: foodModel.protein ?? ""),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    readOnly: isDefault,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Protein(gram)',
                    ),
                    onChanged: (text) {
                      foodModel.protein = text;
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                    controller: TextEditingController(
                        text: foodModel.cholesterol ?? ""),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    readOnly: isDefault,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Cholesterol(gram)',
                    ),
                    onChanged: (text) {
                      foodModel.cholesterol = text;
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                    controller:
                        TextEditingController(text: foodModel.calories ?? ""),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    readOnly: isDefault,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Calo(gram)',
                    ),
                    onChanged: (text) {
                      foodModel.calories = text;
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                    controller:
                        TextEditingController(text: foodModel.fat ?? ""),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    readOnly: isDefault,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Fat(gram)',
                    ),
                    onChanged: (text) {
                      foodModel.fat = text;
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                    controller: TextEditingController(
                        text: foodModel.saturated_fat ?? ""),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    readOnly: isDefault,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Saturated Fat(gram)',
                    ),
                    onChanged: (text) {
                      foodModel.saturated_fat = text;
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                    controller:
                        TextEditingController(text: foodModel.trans_fat ?? ""),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    readOnly: isDefault,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Trans Fat(gram)',
                    ),
                    onChanged: (text) {
                      foodModel.trans_fat = text;
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                    controller:
                        TextEditingController(text: foodModel.sodium ?? ""),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    readOnly: isDefault,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Sodium(gram)',
                    ),
                    onChanged: (text) {
                      foodModel.sodium = text;
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                    controller:
                        TextEditingController(text: foodModel.potassium ?? ""),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    readOnly: isDefault,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Potasium(gram)',
                    ),
                    onChanged: (text) {
                      foodModel.potassium = text;
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                    controller: TextEditingController(
                        text: foodModel.diatery_fiber_sugar ?? ""),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    readOnly: isDefault,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Diatery Fiber Sugar(gram)',
                    ),
                    onChanged: (text) {
                      foodModel.diatery_fiber_sugar = text;
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                    controller:
                        TextEditingController(text: foodModel.vitamin_a ?? ""),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    readOnly: isDefault,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Vitamin A(gram)',
                    ),
                    onChanged: (text) {
                      foodModel.vitamin_a = text;
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                    controller:
                        TextEditingController(text: foodModel.vitamin_c ?? ""),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    readOnly: isDefault,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Vitamin C(gram)',
                    ),
                    onChanged: (text) {
                      foodModel.vitamin_c = text;
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                    controller:
                        TextEditingController(text: foodModel.iron ?? ""),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    readOnly: isDefault,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Iron(gram)',
                    ),
                    onChanged: (text) {
                      foodModel.iron = text;
                    }),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
                controller:
                    TextEditingController(text: foodModel.meal_volume ?? ""),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Total(gram)',
                ),
                onChanged: (text) {
                  foodModel.meal_volume = text;
                }),
          ),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                      return Colors.blue.withOpacity(0.04);
                    if (states.contains(MaterialState.focused) ||
                        states.contains(MaterialState.pressed))
                      return Colors.blue.withOpacity(0.12);
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () async {
                if (foodModel.name == null || foodModel.name?.isEmpty == true) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Vui lòng nhập tên"),
                  ));
                } else if (foodModel.date?.isEmpty == true) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Vui lòng chọn thời gian"),
                  ));
                } else {
                  var food = {
                    DatabaseHelper.columnId: foodModel.id,
                    DatabaseHelper.columnMealDate: date,
                    DatabaseHelper.columnCalories: foodModel.calories,
                    DatabaseHelper.columnTransFat: foodModel.trans_fat,
                    DatabaseHelper.columnCalcium: foodModel.calcium,
                    DatabaseHelper.columnProtein: foodModel.protein,
                    DatabaseHelper.columnMealType: meal.id,
                    DatabaseHelper.columnCholesterol: foodModel.cholesterol,
                    DatabaseHelper.columnName: foodModel.name,
                    DatabaseHelper.columnGram: foodModel.meal_volume,
                    DatabaseHelper.columnIron: foodModel.iron,
                    DatabaseHelper.columnVitaminA: foodModel.vitamin_a,
                    DatabaseHelper.columnVitaminC: foodModel.vitamin_c,
                    DatabaseHelper.columnDiateryFiberSugar:
                        foodModel.diatery_fiber_sugar,
                    DatabaseHelper.columnSodium: foodModel.sodium,
                    DatabaseHelper.columnCarbohydrat: foodModel.carbohydrates,
                    DatabaseHelper.columnPotadium: foodModel.potassium,
                    DatabaseHelper.columnSaturatedFat: foodModel.saturated_fat,
                    DatabaseHelper.columnFat: foodModel.fat,
                    DatabaseHelper.columnType: meal.type,
                    DatabaseHelper.columnCreateAt: meal.createAt,
                    DatabaseHelper.columnSync: false,
                    DatabaseHelper.columnMealType: meal.type,
                    "foodVolume": foodModel.calories,
                  };

                  if (foodModel.meal_volume != null) {
                    food.values.forEach((element) {
                      if (element == null || element == "null") {
                        element = "0";
                      }
                    });
                    food.remove("foodVolume");
                    bool statusSave = false;
                    if (await AppShared.isNetworkAvailable()) {
                      statusSave = await _addFoodToServer(food);
                    } else {
                      statusSave = false;
                    }
                    food[DatabaseHelper.columnSync] = statusSave ? 1 : 0;
                    food.remove("serving_unit");
                    food.remove("serving_weight_grams");
                    food.remove("updated_up");

                    //food
                    food[DatabaseHelper.columnMealDate] = date;
                    int? value = await DatabaseHelper.instance.insertFood(food);
                    if (value != null && value != 0) {
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Add failed")));
                    }
                  } else {
                    AppShared.showMessage("Please input total gram");
                  }
                }
              },
              child: Text('NOTE'))
        ],
      ),
    );
  }

  Widget viewChooseGroup() {
    return InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: 200,
                    child: ListView.builder(
                        itemCount: groups.length,
                        itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              setState(() {
                                foodGroup = groups[index];
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(8),
                                  child: Text(
                                    groups[index].groupName ?? "",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: double.infinity,
                                )
                              ],
                            ))),
                  ),
                );
              });
        },
        child: Row(
          children: [
            Text(foodGroup?.groupName ?? ""),
            Icon(Icons.arrow_drop_down)
          ],
        ));
  }

  Future<bool> _addFoodToServer(Map<String, dynamic> params) async {
    if (foodModel.isDefault == true) {
      if (!isDefault) {
        setState(() {});
        return true;
      } else {
        AppShared.showLoading(context);
        //tạo món vào bữa
        var resCreate = await Service().call?.post(
            "api/mealstracking/create/userstracking/${SPref().id}/mealstracking",
            data: {
              "name": meal.name,
              "description": null,
              "type": meal.type,
              "created_at": "$date"
            }).catchError((onError) {
          AppShared.hideLoading(context);
          if (onError is DioError && onError.response?.statusCode == 401) {
            SPref().id = 0;
            Navigator.pushReplacementNamed(context, LoginPage.routeName);
          } else {
            Navigator.pop(context);
            AppShared.showMessage(
                "Have error Try again");
          }
        });

        var res = await Service().call?.post(
            "api/food/add/mealstracking/${resCreate?.data["id"]}/food",
            data: {
              "food": {
                "id": foodModel.id,
              },
              "food_volume": foodModel.meal_volume
            }).catchError((onError) {
          AppShared.hideLoading(context);
          print(onError.toString());
          AppShared.showMessage(onError.response.data["message"], isRed: true);
        });
        AppShared.hideLoading(context);
        AppShared.showMessage("Success");
        return res?.statusCode == 200;
      }
    } else {
      //tạo món vào bữa
      AppShared.showLoading(context);
      print('The value of the input is: ');
      var resCreate = await Service().call?.post(
          "api/mealstracking/create/userstracking/${SPref().id}/mealstracking",
          data: {
            "name": meal.name,
            "description": null,
            "type": meal.type,
            "created_at": "$date"
          }).catchError((onError) {
        AppShared.hideLoading(context);
        if (onError is DioError && onError.response?.statusCode == 401) {
          SPref().id = 0;
          Navigator.pushReplacementNamed(context, LoginPage.routeName);
        }
        print(onError.toString());
      });

      //tạo food vào meal
      var code = 0;
      if (resCreate?.statusCode == 200) {
        var res = await Service().call?.post(
            "api/food/add/mealstracking/${resCreate?.data["id"]}/food",
            data: {
              "food": {
                "id": 1,
                "name": foodModel.name,
                "foodGroup": {
                  "id": foodGroup?.id,
                  "group_name": foodGroup?.groupName
                }
              },
              "food_volume": foodModel.meal_volume
            }).catchError((onError) {
          AppShared.hideLoading(context);
          print(onError.message.toString());
          AppShared.showMessage(onError.response.data["message"], isRed: true);
        });
        if (res?.statusCode == 200) {
          await Future.delayed(Duration(seconds: 10));
          params["serving_unit"] = "g";
          params["serving_weight_grams"] = 100.0;
          params['updated_up'] = null;
          //remove dư parma
          params.remove("id");
          params.remove("date");
          var resUpdate;
          try {
            resUpdate = await Service()
                .call
                ?.put("api/nutritionfact/update/food/${res?.data["id"]}",
                data: params)
                .catchError((onError) {
              AppShared.hideLoading(context);
              print(onError.toString());
              AppShared.showMessage(onError.response.data["message"],
                  isRed: true);
            });
          } catch(error) {
            code = 0;
          }
          AppShared.hideLoading(context);
          code = resUpdate?.statusCode ?? 0;
        }
      }
      return code == 200;
    }
  }
}
