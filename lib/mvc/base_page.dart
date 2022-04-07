import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dx_plugin/dx_plugin.dart';

abstract class BasePage<T extends BaseController> {
  late ColorScheme mColors;
  late T mController;

  void initBase(T controller, BuildContext context) {
    mController = Get.put(controller);
    _init(context);
  }

  ///tag遞增 controller
  void initRepeat<K extends GetRepeatController>(
      K controller, BuildContext context) {
    mController = GetRepeatController.getController<K>(controller) as T;
    _init(context);
  }

  void _init(BuildContext context) {
    mColors = context.colors;
  }
}
