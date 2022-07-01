import 'package:shared_preferences/shared_preferences.dart';

class SPref {
  static final SPref _ins = SPref._();
  late SharedPreferences _preferences;

  factory SPref() {
    return _ins;
  }

  final String kToken = "Token";
  final String kUserName = "UserName";
  final String kId = "ID";
  final String kCreate = "Create";
  final String kName = "Name";
  final String kEmail = "Email";
  final String kAvt = "Avt";

  init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  String get token => _preferences.getString(kToken) ?? "";

  set token(String value) {
    _preferences.setString(kToken, value);
  }

  String get userName => _preferences.getString(kUserName) ?? "";

  set userName(String value) {
    _preferences.setString(kUserName, value);
  }

  int get id => _preferences.getInt(kId) ?? 0;

  set id(int value) {
    _preferences.setInt(kId, value);
  }

  bool get isCreate => _preferences.getBool(kCreate) ?? false;

  set isCreate(bool value) {
    _preferences.setBool(kCreate, value);
  }

  String get name => _preferences.getString(kName) ?? "";

  set name(String value) {
    _preferences.setString(kName, value);
  }

  String get email => _preferences.getString(kEmail) ?? "";

  set email(String value) {
    _preferences.setString(kEmail, value);
  }

  String get avt => _preferences.getString(kAvt) ?? "";

  set avt(String value) {
    _preferences.setString(kAvt, value);
  }

  SPref._();
}
