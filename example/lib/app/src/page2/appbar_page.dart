import 'package:common/base/mvvm/view/base_appbar_page.dart';
import 'package:common/common/top.dart';
import 'package:flutter/material.dart';

import 'appbar_page_controller.dart';

class AppBarPage extends BaseAppBarPage<AppBarPageController> {
  const AppBarPage({super.key});

  @override
  String get appBarTitle => "title";

  @override
  Color? get statusBarColor => Colors.cyan;

  @override
  onTapRight(BuildContext context) async {
    showToast("tap right");
  }

  @override
  Widget buildContent(BuildContext context) {
    return const Center(
      child: Text('appbar_page'),
    );
  }
}
