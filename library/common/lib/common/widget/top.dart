import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 打开日期选择器
Future<DateTime?> showDate(BuildContext context, {String? dateTime}) async {
  DateTime _dateTime;
  if (dateTime?.isNotEmpty == true) {
    _dateTime = DateFormat('MM/dd/yyyy').parse(dateTime!);
  } else {
    _dateTime = DateTime.now();
  }
  return await showDatePicker(
    context: context,
    initialDate: _dateTime,
    firstDate: DateTime(1920),
    lastDate: DateTime.now(),
  );
}

/// 打开时间选择器
Future<TimeOfDay?> showTime(BuildContext context) async {
  return await showTimePicker(context: context, initialTime: TimeOfDay.now());
}
