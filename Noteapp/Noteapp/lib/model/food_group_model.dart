import '../db/my_database.dart';

class FoodGroup {
  FoodGroup({
    this.id,
    this.groupName,
  });

  FoodGroup.fromJson(dynamic json) {
    id = json['id'];
    groupName = json['group_name'];
  }

  int? id;
  String? groupName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['group_name'] = groupName;
    return map;
  }
}
