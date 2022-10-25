library common;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';

// parts
part 'widget/text/no_border_text_field.dart';

part 'widget/dialog/a_image_picker.dart';

part 'widget/dialog/confirm_dialog.dart';

part 'widget/checkbox/stful_check_box.dart';

part 'ext/color.dart';

part 'ext/save_utils.dart';

part 'ext/standard.dart';

/// 弹出toast
/// 默认样式
showToast(String? msg) {
  Fluttertoast.showToast(msg: msg ?? "");
}

/// 打开日期选择器
Future<DateTime?> showDate(BuildContext context, {String? dateTime}) async {
  DateTime? _dateTime;
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
