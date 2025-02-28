import 'package:common/base/mvvm/view/base_view_interface.dart';
import 'package:common/base/mvvm/vm/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseViewPage<c extends BaseViewModel> extends StatelessWidget
    with BaseViewInterface<c> {
  final c controller;

  const BaseViewPage({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => buildController(context),
      child: buildContent(context, controller),
    );
  }

  @override
  buildController(BuildContext context) {
    controller.onInit();
    return controller;
  }
}
