import 'dart:convert';

import 'package:cs/db/my_database.dart';
import 'package:cs/helper/spref.dart';
import 'package:flutter/cupertino.dart';

import '../server/service.dart';
import 'app_shared.dart';
import 'package:cs/extensions/extensions.dart';

class SyncData {
  static onSyncLocalData(BuildContext context) {
    DatabaseHelper.instance.getAllFood().then((value) {
      value.forEach((foodModel) async {
        if (foodModel.isSync != true) {
          if (foodModel.isDefault == true) {
            var resCreate = await Service().call?.post(
                "api/mealstracking/create/userstracking/${SPref().id}/mealstracking",
                data: {
                  "name": "",
                  "description": null,
                  "type": foodModel.mealId,
                  "created_at": "${foodModel.date}"
                });
            var res = await Service().call?.post(
                "api/food/add/mealstracking/${resCreate?.data["id"]}/food",
                data: {
                  "food": {
                    "id": foodModel.id,
                  },
                  "food_volume": foodModel.meal_volume
                });
            if (res?.statusCode == 200) {
              DatabaseHelper.instance.updateFood(foodModel.id, 1);
            }
          } else {
            //tạo món vào bữa
            var params = foodModel.toJson();
            var resCreate = await Service().call?.post(
                "api/mealstracking/create/userstracking/${SPref().id}/mealstracking",
                data: {
                  "name": "",
                  "description": null,
                  "type": foodModel.mealId,
                  "created_at": "${foodModel.date}"
                });
            //tạo food vào meal
            if (resCreate?.statusCode == 200) {
              var res = await Service().call?.post(
                  "api/food/add/mealstracking/${resCreate?.data["id"]}/food",
                  data: {
                    "food": {
                      "id": 1,
                      "name": foodModel.name,
                      "foodGroup": {
                        "id": foodModel.groupID,
                        "group_name": foodModel.groupName
                      }
                    },
                    "food_volume": foodModel.meal_volume
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
                } catch (error) {}
                AppShared.hideLoading(context);
                if (resUpdate?.statusCode == 200) {
                  DatabaseHelper.instance.updateFood(foodModel.id, 1);
                }
              }
            }
          }
        }
      });
    });
  }

  static onSyncAct(BuildContext context) {
    DatabaseHelper.instance.getAllActivities().then((value) {
      value.forEach((activityModel) async {
        if (activityModel.isSync != true) {
          if (activityModel.isDefault == true) {
            var res = await Service().call?.post(
                "api/activitiestracking/create/userstracking/${SPref().id}/activitiestracking",
                data: {
                  "id": activityModel.id,
                  "start_time":
                      "${activityModel.date?.replaceFirst(RegExp(r' '), "T")}+00:00",
                  "end_time": activityModel.date!
                          .plusDuration(
                              int.parse(activityModel.duration ?? "0"))
                          .replaceFirst(" ", "T") +
                      "+00:00",
                  "listActivities": {"id": 1}
                });
            if (res?.statusCode == 200) {
              DatabaseHelper.instance.updateAct(activityModel.id, 1);
            }
          } else {
            var res = await Service().call?.post(
                "api/activitiestracking/create/userstracking/${SPref().id}/activitiestracking",
                data: jsonEncode({
                  "id": 1000,
                  "start_time":
                      "${activityModel.date?.replaceFirst(RegExp(r' '), "T")}+00:00",
                  "end_time": activityModel.date!
                          .plusDuration(
                              int.parse(activityModel.duration ?? "0"))
                          .replaceFirst(RegExp(r' '), "T") +
                      "+00:00",
                  "listActivities": {
                    "id": 1000,
                    "name": activityModel.name,
                    "calo_per_hour": activityModel.caloLos
                  }
                }));
            if (res?.statusCode == 200) {
              DatabaseHelper.instance.updateAct(activityModel.id, 1);
            }
          }
        }
      });
    });
  }
}
