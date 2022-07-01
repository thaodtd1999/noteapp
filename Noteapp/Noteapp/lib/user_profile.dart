import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cs/helper/spref.dart';
import 'package:cs/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';

import 'helper/app_shared.dart';
import 'login.dart';
import 'model/user_tracking_model.dart';
import 'server/service.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  static var routeName = "/profile";

  @override
  _UserProfileState createState() => _UserProfileState();
}

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTH_NOT_GRANTED
}

class _UserProfileState extends State<UserProfile> {
  static HealthFactory health = HealthFactory();
  UserModel userModel = UserModel();
  UserTrackingModel? userTrackingModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      getData();
    });
  }

  Future fetchHealthData() async {
    AppShared.showLoading(context);
    // define the types to get
    List<HealthDataType> types = [
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.HEART_RATE,
      HealthDataType.WATER,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC
    ];

    final now = DateTime.now();

    final yesterday = now.subtract(const Duration(days: 100));

    List<HealthDataPoint> healthData = [];

    bool requested = await health.requestAuthorization(types);

    if (requested) {
      healthData = await health.getHealthDataFromTypes(yesterday, now, types);
    }
    healthData.forEach((element) {
      if (element.type == HealthDataType.WEIGHT) {
        userModel.currentWeight = element.value.toString();
      }
      if (element.type == HealthDataType.HEIGHT) {
        userModel.currentHeight = element.value.toString();
      }
      if (element.type == HealthDataType.BLOOD_PRESSURE_DIASTOLIC) {
        if (element.value > 80) {
          AppShared.showMessage("Warning\n Systolic too high", isRed: true);
        }
        if (element.value < 60) {
          AppShared.showMessage("Warning\n Systolic too low", isRed: true);
        }
        userModel.currentDiastolic = element.value.toString();
      }
      if (element.type == HealthDataType.BLOOD_GLUCOSE) {
        userModel.currentNormalBlood = element.value.toString();
      }
      if (element.type == HealthDataType.BLOOD_PRESSURE_SYSTOLIC) {
        if (element.value > 120) {
          AppShared.showMessage("Warning\n Systolic too high", isRed: true);
        }
        if (element.value < 80) {
          AppShared.showMessage("Warning\n Systolic too low", isRed: true);
        }
        userModel.currentSystolic = element.value.toString();
      }
    });
    AppShared.hideLoading(context);
    setState(() {});
  }

  Widget _content() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 56,
                    backgroundColor: Colors.red,
                    backgroundImage: SPref().avt == ""
                        ? AssetImage("assets/food.jpg")
                        : null,
                    child: SPref().avt != ""
                        ? Image.file(File(SPref().avt))
                        : null,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Information",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  readOnly: true,
                  initialValue: userTrackingModel?.name,
                  onChanged: (text) {
                    userTrackingModel?.name = text;
                  },
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  key: UniqueKey(),
                  initialValue: userTrackingModel?.email,
                  decoration: InputDecoration(labelText: 'Email'),
                  readOnly: true,
                  onChanged: (text) {
                    userTrackingModel?.email = text;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  "Healthy Indicator",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            key: UniqueKey(),
                            initialValue: userModel.currentHeight ?? "",
                            decoration: InputDecoration(labelText: 'Height'),
                            keyboardType: TextInputType.number,
                            onChanged: (text) {
                              userModel.currentHeight = text;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          TextFormField(
                            key: UniqueKey(),
                            initialValue: userModel.currentWeight ?? "",
                            decoration: InputDecoration(labelText: 'Weight'),
                            keyboardType: TextInputType.number,
                            onChanged: (text) {
                              userModel.currentWeight = text;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  key: UniqueKey(),
                  initialValue: userModel.currentBloodBeforeMeal == "null"
                      ? ""
                      : userModel.currentBloodBeforeMeal ?? "",
                  decoration: InputDecoration(labelText: 'Before Meal'),
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    userModel.currentWeight = text;
                  },
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  key: UniqueKey(),
                  initialValue: userModel.currentDiastolic == "null"
                      ? ""
                      : userModel.currentDiastolic ?? "",
                  decoration: InputDecoration(labelText: 'Diasotolic'),
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    userModel.currentDiastolic = text;
                  },
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  key: UniqueKey(),
                  initialValue: userModel.currentSystolic == "null"
                      ? ""
                      : userModel.currentSystolic ?? "",
                  decoration: InputDecoration(labelText: 'Systolic'),
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    userModel.currentSystolic = text;
                  },
                ),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  key: UniqueKey(),
                  initialValue: userModel.currentNormalBlood == "null"
                      ? ""
                      : userModel.currentNormalBlood ?? "",
                  decoration: InputDecoration(labelText: 'Normal Blood'),
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    userModel.currentNormalBlood = text;
                  },
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: userModel.isBloodPressureDiseases == true,
                        onChanged: (status) {
                          setState(() {
                            userModel.isBloodPressureDiseases = status;
                          });
                        }),
                    const SizedBox(
                      width: 4,
                    ),
                    Text("Blood Pressure Diseases")
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: userModel.isDiabatesMeltiyus == true,
                        onChanged: (status) {
                          setState(() {
                            userModel.isDiabatesMeltiyus = status;
                          });
                        }),
                    const SizedBox(
                      width: 4,
                    ),
                    Text("Diabetes Mellitus")
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: userModel.isHeartDiseases == true,
                        onChanged: (status) {
                          setState(() {
                            userModel.isHeartDiseases = status;
                          });
                        }),
                    const SizedBox(
                      width: 4,
                    ),
                    Text("Heart Diseases")
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextButton(
              onPressed: () {
                SPref().id = 0;
                Navigator.pushReplacementNamed(context, LoginPage.routeName);
              },
              child: Text("Logout"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text(SPref().name),
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_sharp,
                  color: Colors.blue,
                )),
            actions: [
              InkWell(
                  onTap: () {
                    _onSave();
                  },
                  child: Icon(
                    Icons.check,
                    color: Colors.blue,
                  )),
              const SizedBox(
                width: 16,
              ),
              InkWell(
                  onTap: () {
                    fetchHealthData();
                  },
                  child: Icon(
                    Icons.download,
                    color: Colors.blue,
                  ))
            ],
          ),
          body: Container(
            color: Colors.white,
            child: Center(
              child: _content(),
            ),
          )),
    );
  }

  getData() async {
    AppShared.showLoading(context);
    var res = await Service()
        .call
        ?.get("api/auth/details/${SPref().userName}")
        .catchError((onError) {
      AppShared.hideLoading(context);
      print(onError.toString());
      if (onError is DioError && onError.response?.statusCode == 401) {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      }
      AppShared.showMessage(onError.response.data["message"], isRed: true);
    });
    AppShared.hideLoading(context);
    if (res?.statusCode == 200) {
      userTrackingModel = UserTrackingModel.fromJson(res?.data);
      userModel = userTrackingModel!.usersTracking!;
      setState(() {});
    } else {
      AppShared.showMessage("Have a error \n Please try again", isRed: true);
    }
  }

  _onSave() async {
    AppShared.showLoading(context);
    var res = await Service()
        .call
        ?.put("api/userstracking/update/${SPref().id}",
            data: jsonEncode({
              "is_diabates_meltiyus": userModel.isDiabatesMeltiyus,
              "is_blood_pressure_diseases": userModel.isBloodPressureDiseases,
              "is_heart_diseases": userModel.isHeartDiseases,
              "current_height": userModel.currentHeight,
              "current_weight": userModel.currentWeight,
              "current_diastolic": userModel.currentDiastolic,
              "current_systolic": userModel.currentSystolic,
              "current_blood_before_meal": userModel.currentBloodBeforeMeal,
              "current_normal_blood": userModel.currentNormalBlood
            }))
        .catchError((onError) {
      AppShared.hideLoading(context);
      print(onError.toString());
      AppShared.showMessage(onError.response.data["message"], isRed: true);
    });
    AppShared.hideLoading(context);
    if (res?.statusCode == 200) {
      AppShared.showMessage("Success");
    } else {
      AppShared.showMessage("Have a error \n Please try again", isRed: true);
    }
  }
}
