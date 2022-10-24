import 'package:base/route/a_route.dart';
import 'package:common/launcher/a_launcher_strategy.dart';
import 'package:common/log/a_logger.dart';
import 'package:flutter/material.dart';
import 'package:sample/base/build_config.dart';
import 'package:get/get.dart';
import 'package:sample/base/config/route_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base/app/base_app.dart';

/// app
// ignore: must_be_immutable
class MyApp extends BaseApp {
  MyApp({
    super.key,
    required ALauncherStrategy launcherStrategy,
    required ARoute route,
  }) : super(launcherStrategy: launcherStrategy, route: route);

  @override
  void setBuildConfig(ALauncherStrategy launcherStrategy) {
    String env = launcherStrategy.envName;
    String host = launcherStrategy.host;
    bool isDebug = launcherStrategy.isDebug;
    logI(
        "my_app.dart: launcher strategy env: $env, isDebug: $isDebug, host: $host");
    BuildConfig.envName = env;
    BuildConfig.isDebug = isDebug;
    BuildConfig.host = host;
  }
}
