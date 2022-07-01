class UserModel {
  UserModel({
      this.id, 
      this.isDiabatesMeltiyus, 
      this.isBloodPressureDiseases, 
      this.isHeartDiseases, 
      this.currentHeight, 
      this.currentWeight, 
      this.currentDiastolic, 
      this.currentSystolic, 
      this.currentBloodBeforeMeal, 
      this.currentNormalBlood,});

  UserModel.fromJson(dynamic json) {
    id = json['id'].toString();
    isDiabatesMeltiyus = json['is_diabates_meltiyus'];
    isBloodPressureDiseases = json['is_blood_pressure_diseases'];
    isHeartDiseases = json['is_heart_diseases'];
    currentHeight = json['current_height'].toString();
    currentWeight = json['current_weight'].toString();
    currentDiastolic = json['current_diastolic'].toString();
    currentSystolic = json['current_systolic'].toString();
    currentBloodBeforeMeal = json['current_blood_before_meal'].toString();
    currentNormalBlood = json['current_normal_blood'].toString();
  }
  String? id;
  bool? isDiabatesMeltiyus;
  bool? isBloodPressureDiseases;
  bool? isHeartDiseases;
  String? currentHeight;
  String? currentWeight;
  String? currentDiastolic;
  String? currentSystolic;
  String? currentBloodBeforeMeal;
  String? currentNormalBlood;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['is_diabates_meltiyus'] = isDiabatesMeltiyus;
    map['is_blood_pressure_diseases'] = isBloodPressureDiseases;
    map['is_heart_diseases'] = isHeartDiseases;
    map['current_height'] = currentHeight;
    map['current_weight'] = currentWeight;
    map['current_diastolic'] = currentDiastolic;
    map['current_systolic'] = currentSystolic;
    map['current_blood_before_meal'] = currentBloodBeforeMeal;
    map['current_normal_blood'] = currentNormalBlood;
    return map;
  }

}