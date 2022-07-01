import '../db/my_database.dart';

class ActivitySearchModel {
  int id;
  String name;
  double? calo_per_hour;

  ActivitySearchModel(
      {required this.name, required this.id, required this.calo_per_hour});

  static ActivitySearchModel fromSQLJson(Map<String, dynamic> json) => ActivitySearchModel(
      id: json[DatabaseHelper.columnIdActivity],
      name: json[DatabaseHelper.columnNameActivity],
      calo_per_hour: double.parse(json[DatabaseHelper.colCaloPerHour]));

  static ActivitySearchModel fromJson(Map<String, dynamic> json) => ActivitySearchModel(
      id: json['id'], name: json['name'], calo_per_hour: json['calo_per_hour']);
}
