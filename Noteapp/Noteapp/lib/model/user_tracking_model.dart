import 'package:cs/model/user_model.dart';

class UserTrackingModel {
  UserTrackingModel({
      this.id, 
      this.username, 
      this.email, 
      this.password, 
      this.name, 
      this.birthday, 
      this.isActive, 
      this.usersTracking, 
      this.roles,});

  UserTrackingModel.fromJson(dynamic json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    name = json['name'];
    birthday = json['birthday'];
    isActive = json['is_active'];
    usersTracking = json['usersTracking'] != null ? UserModel.fromJson(json['usersTracking']) : null;
    if (json['roles'] != null) {
      roles = [];
      json['roles'].forEach((v) {
        roles?.add(Roles.fromJson(v));
      });
    }
  }
  int? id;
  String? username;
  String? email;
  String? password;
  dynamic name;
  dynamic birthday;
  dynamic isActive;
  UserModel? usersTracking;
  List<Roles>? roles;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['username'] = username;
    map['email'] = email;
    map['password'] = password;
    map['name'] = name;
    map['birthday'] = birthday;
    map['is_active'] = isActive;
    if (usersTracking != null) {
      map['usersTracking'] = usersTracking?.toJson();
    }
    if (roles != null) {
      map['roles'] = roles?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Roles {
  Roles({
      this.id, 
      this.name,});

  Roles.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  int? id;
  String? name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}
