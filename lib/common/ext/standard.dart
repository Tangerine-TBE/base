import 'package:common/base/app/base_material_app.dart';
import 'package:common/common/get_utils/src/get_utils/get_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension NullStringExt on String? {
  String get val => isNullOrEmpty ? '' : this!;

  bool isNum(String value) => GetUtils.isNum(value);
}

extension StringExt on String {
  // this 作為key，去storage中讀寫值
  save(dynamic value) async {
    if (value is String) {
      perference?.setString(this, value);
    } else if (value is double) {
      perference?.setDouble(this, value);
    } else if (value is int) {
      perference?.setInt(this, value);
    } else if (value is bool) {
      perference?.setBool(this, value);
    } else {
      throw FlutterError('the type must be int,double,bool or String');
    }
  }

  get read => perference?.get(this);
}

extension NullNumExt on num? {
  num get val => isNullOrEmpty ? 0 : this!;
}

extension IntExt on int? {
  int get val => isNullOrEmpty ? 0 : this!;
}

extension DoubleExt on double? {
  double get val => isNullOrEmpty ? 0 : this!;
}

extension BoolExt on bool? {
  bool get val => this == null ? false : this == true;
}

extension Dynamic on dynamic {
  bool get isEmpty => GetUtils.isBlank(this) == true;

  bool get isNullOrEmpty => GetUtils.isNullOrBlank(this) == true;
}
