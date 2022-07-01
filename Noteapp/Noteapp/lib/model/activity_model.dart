import '../db/my_database.dart';

class ActivityModel {
  int id;
  String name;
  String? caloLos;
  String? duration;
  String? date;
  bool? isSync;
  bool? isDefault;

  ActivityModel(
      {required this.name,
      required this.date,
      required this.id,
      this.caloLos,
      this.duration,
      this.isSync,
      this.isDefault});

  static ActivityModel fromJson(Map<String, dynamic> json) => ActivityModel(
      id: json[DatabaseHelper.columnIdActivity],
      name: json[DatabaseHelper.columnNameActivity],
      caloLos: json[DatabaseHelper.columnCaloLess],
      duration: json[DatabaseHelper.columnDurationActivity],
      date: json[DatabaseHelper.columnDateActivity],
      isSync: json[DatabaseHelper.columnSync] == 1,
      isDefault: json[DatabaseHelper.columnForSearch] == 1 ? true : false);
}
