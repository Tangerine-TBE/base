import 'package:common/base/mvvm/view/base_launcher_page.dart';
import 'package:common/common/startup/startup.dart';
import 'package:flutter/material.dart';

import '../../../app_base/config/route_name.dart';
import '../config/startup_config.dart';
import 'home_page_controller.dart';

class HomePage extends BaseLauncherPage<HomePageController> {
  HomePage({super.key});

  @override
  List<Color> get gradientColors => [Colors.greenAccent, Colors.blueAccent];

  @override
  Map<String, Startup>? loadStartups() => startupMap;

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
