import 'package:common/base/mvvm/view/base_view_interface.dart';
import 'package:common/base/mvvm/vm/base_view_model.dart';
import 'package:flutter/material.dart';


abstract class BaseViewPage<c extends BaseViewModel> extends StatelessWidget
    with BaseViewInterface<c> {
  final c controller;
  const BaseViewPage({Key? key,required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildContent(context,buildController(context) );
  }

  @override
  buildController(BuildContext context) {
    return controller;
  }
}
