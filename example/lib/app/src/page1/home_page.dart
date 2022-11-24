import 'package:common/base/mvvm/view/base_gradient_page.dart';
import 'package:common/common/startup/manager/startup_manager.dart';
import 'package:flutter/material.dart';

import '../../../app_base/config/route_name.dart';
import '../config/startup_config.dart';
import 'home_page_controller.dart';
import 'package:get/get.dart';

class HomePage extends BaseGradientPage<HomePageController> {
  HomePage({super.key}) {
    // 等待页面build完毕，执行startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StartupManager(Get.context!, startupMap).start();
    });
  }

  @override
  AppBar? buildAppBar() => null;

  @override
  Widget? buildDrawer() => null;

  @override
  List<Color> get gradientColors => [Colors.greenAccent, Colors.blueAccent];

  @override
  Widget buildContent(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                navigateTo(RouteName.appBarPage);
              },
              child: const Text("Appbar Page Sample"),
            ),
          ],
        ),
      );
}
