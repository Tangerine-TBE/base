import 'package:base/route/a_route.dart';
import 'package:common/launcher/a_launcher_strategy.dart';
import 'package:common/log/a_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 封装通用app，给客户端项目继承
// ignore: must_be_immutable
abstract class BaseMaterialApp<T extends ALauncherStrategy> extends StatelessWidget {
  BaseMaterialApp(
    this.launcherStrategy,
    this.route, {
    Key? key,
  }) : super(key: key) {
    init();
  }

  /// 启动策略
  late T launcherStrategy;

  /// 页面路由
  late ARoute route;

  /// material app
  GetMaterialApp? buildApp(BuildContext context, Widget? child);

  /// 设置环境变量
  void buildConfig(T launcherStrategy);

  /// 初始化架构内可用的东西
  void init() {
    installLogger();

    buildConfig(launcherStrategy);
  }

  Widget? widget;

  @override
  Widget build(BuildContext context) {
    logI("app start building..");
    widget ??= ScreenUtilInit(
        builder: (context, child) =>
            buildApp(context, child) ??
            GetMaterialApp(
              getPages: route.getPages(),
              initialRoute: route.initialRoute,
            ),
        //设计图尺寸
        // designSize: Size(
        //     GeneralConstant.DESIGN_WIDTH, GeneralConstant.DESIGN_HEIGHT,));
      );
    return widget!;
  }
}
