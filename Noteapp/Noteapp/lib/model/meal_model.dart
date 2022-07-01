class MealModel {
  int id;
  String name;
  String? type;
  String? createAt;

  MealModel({ required this.id, required  this.name, this.type, this.createAt});

  static MealModel fromJson(Map<String, dynamic> json) =>
      MealModel(
        id: json['id'],
        name: json['name'],
      );
}
