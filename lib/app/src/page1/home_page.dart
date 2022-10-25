import 'package:base/mvvm/view/base_page.dart';
import 'package:flutter/material.dart';
import 'package:sample/app_base/config/route_config.dart';

import 'home_page_controller.dart';

class HomePage extends BasePage<HomePageController> {
  const HomePage({super.key});

  @override
  AppBar? buildAppBar() => null;

  @override
  Widget? buildDrawer() => null;

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
