import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

export 'ext/standard.dart';
export 'widget/checkbox/stateful_check_box.dart';
export 'widget/checkbox/stateful_checkbox_group.dart';
export 'widget/text/no_border_text_field.dart';

/// 弹出toast
/// 默认样式
showToast(String? msg) {
  // if (Get.context != null) {
  //   GFToast.showToast(
  //     msg ?? '',
  //     Get.context!,
  //     toastPosition: GFToastPosition.BOTTOM,
  //   );
  // }
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
