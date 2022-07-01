import 'package:cs/model/food_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

extension Dates on DateTime {
  convertToString() {
    return DateFormat("yyyy-MM-dd").format(this);
  }

  String lastDay(int dayAgo, {String? format = 'yyyy-MM-dd'}) {
    return DateFormat(format)
        .format(DateTime(this.year, this.month, this.day - dayAgo));
  }
}

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(alpha, (red * value).round(), (green * value).round(),
        (blue * value).round());
  }
}

extension ListPropertieson on List<FoodModel> {
  String getCalo() {
    double value = 0;
    this.forEach((element) {
      value += double.tryParse(element.calories ?? "0") ?? 0;
    });
    return value.toString();
  }

  String getPro() {
    double value = 0;
    this.forEach((element) {
      value += double.tryParse(element.protein ?? "0") ?? 0;
    });
    return value.toString();
  }

  String getFat() {
    double value = 0;
    this.forEach((element) {
      value += double.tryParse(element.fat ?? "0") ?? 0;
    });
    return value.toString();
  }

  String getSaturated() {
    double value = 0;
    this.forEach((element) {
      value += double.tryParse(element.saturated_fat ?? "0") ?? 0;
    });
    return value.toString();
  }

  String getCholes() {
    double value = 0;
    this.forEach((element) {
      value += double.tryParse(element.cholesterol ?? "0") ?? 0;
    });
    return value.toString();
  }
}

extension StringExt on String {
  String plusDuration(int int) {
    var format = DateFormat("yyyy-MM-dd hh:mm:ss");
    var dateTime = DateFormat("yyyy-MM-dd hh:mm:ss").parse(this);
    var dateTimeTemp = DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute + int, dateTime.second);
    return format.format(dateTimeTemp);
  }
}
