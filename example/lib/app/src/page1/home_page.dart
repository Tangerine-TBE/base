import 'package:common/base/mvvm/view/base_gradient_page.dart';
import 'package:flutter/material.dart';

import '../../../app_base/config/route_name.dart';
import 'home_page_controller.dart';

class HomePage extends BaseGradientPage<HomePageController> {
  const HomePage({super.key});

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
