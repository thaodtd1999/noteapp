import 'dart:convert';
import 'dart:math';

import 'package:cs/db/my_database.dart';
import 'package:cs/extensions/extensions.dart';
import 'package:cs/helper/spref.dart';
import 'package:cs/model/activity_model.dart';
import 'package:cs/model/activity_search_model.dart';
import 'package:cs/server/service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import 'helper/app_shared.dart';
import 'login.dart';

class OthersActivities extends StatefulWidget {
  const OthersActivities({Key? key}) : super(key: key);

  @override
  _OthersActivitiesState createState() => _OthersActivitiesState();
}

class _OthersActivitiesState extends State<OthersActivities> {
  ActivityModel activityModel = ActivityModel(
      name: "", date: DateTime.now().toString(), id: Random().nextInt(1000000));
  List<ActivitySearchModel> activities = [];
  final DateFormat format = DateFormat("yyyy-MM-ddTHH:mm:ssZ");
  String date = DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance
        .getAllActSearch()
        .then((value) => {setState(() => activities.addAll(value))});
  }

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Note activities';
    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      body: view(),
    );
  }

  Widget view() {
    return ListView(
      padding: EdgeInsets.only(left: 8, right: 8),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text("Tìm kiếm"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Autocomplete<ActivitySearchModel>(
            displayStringForOption: (ActivitySearchModel eq) {
              return eq.name.toString();
            },
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<ActivitySearchModel>.empty();
              }
              return activities.where((ActivitySearchModel option) {
                return option.name
                    .toString()
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (ActivitySearchModel eq) async {
              setState(() {
                activityModel = ActivityModel(
                    id: eq.id,
                    caloLos: "0",
                    isDefault: true,
                    name: eq.name,
                    date: DateTime.now().toString());
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            key: Key(activityModel.name),
            initialValue: activityModel.name,
            readOnly: activityModel.isDefault == true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Activity Name',
            ),
            onChanged: (text) {
              activityModel.name = text;
            },
          ),
        ),
        DateTimePicker(
          type: DateTimePickerType.dateTimeSeparate,
          dateMask: 'd MMM, yyyy',
          initialValue: date,
          firstDate: DateTime(2000),
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
          onChanged: (val) => activityModel.date = val,
          validator: (val) {
            print(val);
            return null;
          },
          onSaved: (val) => print(val),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            keyboardType: TextInputType.number,
            key: Key(activityModel.caloLos.toString()),
            initialValue: activityModel.caloLos,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Calo loss',
            ),
            onChanged: (text) {
              activityModel.caloLos = text;
            },
          ),
        ),
        Text(
          'Duration (min)',
          style: TextStyle(
            fontSize: 20,
            color: Colors.teal[300],
          ),
        ),
        NumberInputWithIncrementDecrement(
          controller: TextEditingController(),
          isInt: false,
          incDecFactor: 1,
          initialValue: int.tryParse(activityModel.duration ?? "0") ?? 0,
          onIncrement: (num value) {
            activityModel.duration = value.toString();
          },
          onDecrement: (num newlyDecrementedValue) {
            activityModel.duration = newlyDecrementedValue.toString();
          },
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
              if (activityModel.name == "" ||
                  activityModel.name.isEmpty == true) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Vui lòng nhập tên"),
                ));
              } else if (activityModel.date == "") {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Vui lòng chọn thời gian"),
                ));
              } else if (activityModel.caloLos == null ||activityModel.caloLos == "" || activityModel.caloLos == "0") {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Vui lòng nhập calo"),
                ));
              } else {
                var value = {
                  DatabaseHelper.columnIdActivity: Random().nextInt(1000000),
                  DatabaseHelper.columnNameActivity: activityModel.name,
                  DatabaseHelper.columnDurationActivity: activityModel.duration,
                  DatabaseHelper.columnDateActivity: activityModel.date,
                  DatabaseHelper.columnCaloLess: activityModel.caloLos,
                };
                var status = false;
                if (await AppShared.isNetworkAvailable()) {
                  status = await addToServer(value, activityModel.isDefault);
                }
                value[DatabaseHelper.columnSync] = status ? 1 : 0;
                DatabaseHelper.instance.insertActivity(value).then((value) {
                  AppShared.showMessage("Success");
                  Navigator.pop(context);
                });
              }
            },
            child: Text('NOTE'))
      ],
    );
  }

  Future<bool> addToServer(Map<String, dynamic> data, bool? isDefault) async {
    AppShared.showLoading(context);
    if (isDefault == true) {
      var res = await Service().call?.post(
          "api/activitiestracking/create/userstracking/${SPref().id}/activitiestracking",
          data: {
            "id": activityModel.id,
            "start_time": "${date.replaceFirst(RegExp(r' '), "T")}+00:00",
            "end_time": date
                    .plusDuration(int.parse(activityModel.duration ?? "0"))
                    .replaceFirst(" ", "T") +
                "+00:00",
            "listActivities": {"id": 1}
          }).catchError((onError) {
        AppShared.hideLoading(context);
        if (onError is DioError && onError.response?.statusCode == 401) {
          SPref().id = 0;
          Navigator.pushReplacementNamed(context, LoginPage.routeName);
        } else {
          Navigator.pop(context);
          AppShared.showMessage(
              "Network offline\nFodd will sync when network available");
        }
      });
      AppShared.hideLoading(context);
      AppShared.showMessage("Success");
      return res?.statusCode == 200;
    } else {
      var res = await Service()
          .call
          ?.post(
              "api/activitiestracking/create/userstracking/${SPref().id}/activitiestracking",
              data: jsonEncode({
                "id": 1000,
                "start_time": "${date.replaceFirst(RegExp(r' '), "T")}+00:00",
                "end_time": date
                        .plusDuration(int.parse(activityModel.duration ?? "0"))
                        .replaceFirst(RegExp(r' '), "T") +
                    "+00:00",
                "listActivities": {
                  "id": 1000,
                  "name": activityModel.name,
                  "calo_per_hour": activityModel.caloLos
                }
              }))
          .catchError((onError) {
        AppShared.hideLoading(context);
        if (onError is DioError && onError.response?.statusCode == 401) {
          SPref().id = 0;
          Navigator.pushReplacementNamed(context, LoginPage.routeName);
        }
        Navigator.pop(context);
        AppShared.showMessage(
            "Network offline\nFodd will sync when network available");
      });
      AppShared.hideLoading(context);
      AppShared.showMessage("Success");
      return res?.statusCode == 200;
    }
  }
}
