import 'package:base/mvvm/view/base_page.dart';
import 'package:flutter/material.dart';

import 'home_page_controller.dart';

class HomePage extends BasePage<HomePageController> {
  const HomePage({super.key});

  @override
  AppBar? buildAppBar() => null;

  @override
  Widget? buildDrawer() => null;

  @override
  Widget buildContent(BuildContext context) => Container(
    color: Colors.white30,
  );
}
