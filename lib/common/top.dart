library common_top;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

part 'ext/standard.dart';

part 'widget/checkbox/stateful_check_box.dart';

part 'widget/checkbox/stateful_checkbox_group.dart';

part 'widget/dialog/a_image_picker.dart';

part 'widget/dialog/confirm_dialog.dart';

// parts
part 'widget/text/no_border_text_field.dart';

/// 弹出toast
/// 默认样式
showToast(String? msg) {
  Fluttertoast.showToast(msg: msg ?? "");
}

/// 打开 取消 - 确认 对话框
Future<bool?> showConfirmCancelDialog(
  BuildContext context, {
  String? title,
  String? content,
  required Future<bool> Function() shouldCloseOnConfirm,
  required Function onConfirm,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) => ConfirmDialog(
      title: Text(
        title ?? "标题",
        style: TextStyle(
          fontSize: 14.w,
          color: Theme.of(context).primaryColor,
        ),
      ),
      content: Text(
        content ?? "内容？",
        style: TextStyle(
          fontSize: 14.w,
          color: Theme.of(context).primaryColor,
        ),
      ),
      shouldCloseOnConfirm: shouldCloseOnConfirm,
      onConfirm: onConfirm,
    ),
  );
}

/// 打开日期选择器
Future<DateTime?> showDate(BuildContext context, {String? dateTime}) async {
  DateTime? initDateTime;
  if (dateTime?.isNotEmpty == true) {
    initDateTime = DateFormat('MM/dd/yyyy').parse(dateTime!);
  } else {
    initDateTime = DateTime.now();
  }
  return await showDatePicker(
    context: context,
    initialDate: initDateTime,
    firstDate: DateTime(1920),
    lastDate: DateTime.now(),
  );
}

/// 打开时间选择器
Future<TimeOfDay?> showTime(BuildContext context) async {
  return await showTimePicker(context: context, initialTime: TimeOfDay.now());
}
