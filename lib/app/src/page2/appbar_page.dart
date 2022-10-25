import 'package:base/mvvm/view/base_appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:sample/app/src/page2/appbar_page_controller.dart';

class AppBarPage extends BaseAppBarPage<AppBarPageController> {
  const AppBarPage({super.key});

  @override
  String get appBarTitle => "title";

  @override
  onTapLeft() {
    // TODO: implement onTapLeft
    return super.onTapLeft();
  }

  @override
  onTapRight(BuildContext context) {
    // TODO: implement onTapRight
    return super.onTapRight(context);
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