import 'package:common/base/mvvm/view/base_launcher_page.dart';
import 'package:common/common/startup/startup.dart';
import 'package:common/common/top.dart';
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
  Widget? buildBottomNavigation() => BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.backup_rounded),
            label: '云文件',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: '时间',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.snooze),
            label: '闹钟',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.snowboarding_rounded),
            label: '滑雪',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        unselectedLabelStyle: TextStyle(fontSize: 11),
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        onTap: (index) => showToast("$index"),
      );

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
              child: const Text("Appbar Page Sample, color blue"),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                navigateTo(RouteName.appBarPage2);
              },
              child: const Text("Appbar Page Sample, color amber"),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                navigateTo(RouteName.download);
              },
              child: const Text("Download Page Sample"),
            ),
          ],
        ),
      );
}
