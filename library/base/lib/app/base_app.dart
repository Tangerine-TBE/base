import 'package:flutter/material.dart';
import 'package:base/route/a_route.dart';
import 'package:common/launcher/a_launcher_strategy.dart';
import 'package:common/log/a_logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 封装通用app，给客户端项目继承
// ignore: must_be_immutable
abstract class BaseApp extends StatelessWidget {
  BaseApp({
    Key? key,
    required this.launcherStrategy,
    required this.route,
  }) : super(key: key) {
    _init();
  }

  /// 启动策略
  late ALauncherStrategy launcherStrategy;

  /// 页面路由
  late ARoute route;

  /// 设置环境变量
  void setBuildConfig(ALauncherStrategy launcherStrategy);

  /// 初始化架构内可用的东西
  void _init() {
    installLogger();

    setBuildConfig(launcherStrategy);
  }

  @override
  Widget build(BuildContext context) {
    logI("app start building..");
    // TODO build进入两次的问题
    return ScreenUtilInit(
      builder: (context, child) => GetMaterialApp(
        getPages: route.getPages(),
        initialRoute: route.initialRoute,
      ),
      //设计图尺寸
      // designSize: Size(
      //     GeneralConstant.DESIGN_WIDTH, GeneralConstant.DESIGN_HEIGHT,));
    );
  }

}
