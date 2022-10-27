import 'package:common/base/mvvm/view/base_appbar_page.dart';
import 'package:common/common/top.dart';
import 'package:flutter/material.dart';

import 'appbar_page_controller.dart';

class AppBarPage extends BaseAppBarPage<AppBarPageController> {
  const AppBarPage({super.key});

  @override
  String get appBarTitle => "title";

  @override
  onTapLeft() {
    return super.onTapLeft();
  }

  @override
  onTapRight(BuildContext context) async {
    showToast("tap right");
    await controller.fetchMenuStatus();
  }

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      color: Colors.orangeAccent,
      alignment: Alignment.center,
      child: const Text("自带appbar的page演示"),
    );
  }

}