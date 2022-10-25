import 'package:base/app/base_material_app.dart';
import 'package:base/route/a_route.dart';
import 'package:common/log/a_logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/launcher/strategy/base_sample_launcher_strategy.dart';
import 'package:sample/app_base/build_config.dart';

/// app
// ignore: must_be_immutable
class MyApp extends BaseMaterialApp<BaseSampleLauncherStrategy> {
  MyApp({
    super.key,
    required BaseSampleLauncherStrategy launcherStrategy,
    required ARoute route,
  }) : super(launcherStrategy, route);

  @override
  void init() {
    super.init();
    // 强制竖屏
    logI("do your initialization");
  }

  @override
  void buildConfig(BaseSampleLauncherStrategy launcherStrategy) {
    String env = launcherStrategy.envName;
    String host = launcherStrategy.host;
    bool isDebug = launcherStrategy.isDebug;
    String proxy = launcherStrategy.proxy;
    logI(
        "my_app.dart: launcher strategy env: $env, isDebug: $isDebug, host: $host, proxy: $proxy");
    BuildConfig.envName = env;
    BuildConfig.isDebug = isDebug;
    BuildConfig.host = host;
  }

  @override
  GetMaterialApp? buildApp(BuildContext context, Widget? child) =>
      GetMaterialApp(
        getPages: route.getPages(),
        initialRoute: route.initialRoute,
        defaultTransition: Transition.rightToLeftWithFade,
      );
}
