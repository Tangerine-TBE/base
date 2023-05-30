import 'package:common/base/mvvm/view/base_appbar_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'appbar_page_controller.dart';

class AppBarPage2 extends BaseAppBarPage<AppBarPageController> {
  const AppBarPage2({super.key});

  @override
  String get appBarTitle => 'appbar_page2';

  @override
  Color? get statusBarColor => Colors.amber;

  @override
  Widget buildContent(BuildContext context) {
    return const Center(
      child: Text('appbar_page2'),
    );
  }
}
