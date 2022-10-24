import 'package:base/route/a_route.dart';
import 'package:common/launcher/a_launcher_strategy.dart';
import 'package:common/log/a_logger.dart';
import 'package:flutter/material.dart';
import 'package:sample/base/build_config.dart';
import 'package:get/get.dart';
import 'package:sample/base/config/route_config.dart';

/// app
// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.launcherStrategy,
    required this.route,
  }) {
    _init();
    String env = launcherStrategy.envName;
    String host = launcherStrategy.host;
    bool isDebug = launcherStrategy.isDebug;
    logI(
        "my_app.dart: launcher strategy env: $env, isDebug: $isDebug, host: $host");
    BuildConfig.envName = env;
    BuildConfig.isDebug = isDebug;
    BuildConfig.host = host;
  }

  /// 启动策略
  late ALauncherStrategy launcherStrategy;

  /// 页面路由
  late ARoute route;

  /// 三方库等的初始化操作
  void _init() {
    installLogger();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: route.getPages(),
      initialRoute: RouteName.home,
    );
  }

}
