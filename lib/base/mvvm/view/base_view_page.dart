import 'package:common/base/mvvm/view/base_view_interface.dart';
import 'package:common/base/mvvm/vm/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class BaseViewPage<c extends BaseViewModel> extends StatelessWidget
    with BaseViewInterface<c> {
  const BaseViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return buildContent(context,buildController(context) );
  }

  @override
  buildController(BuildContext context) {
    return GoRouterState.of(context).extra! as c;
  }
}
