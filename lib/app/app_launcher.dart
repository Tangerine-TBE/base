import 'package:common/launcher/a_launcher_strategy.dart';
import 'package:flutter/cupertino.dart';
import 'package:sample/base/config/route_config.dart';
import 'package:sample/app/src/my_app.dart';

/// app启动器
class AppLauncher {
  /// 启动 - 通过启动策略启动
  static void launch(
    ALauncherStrategy launcherStrategy,
  ) {
    runApp(MyApp(
      launcherStrategy: launcherStrategy,
      route: RouteConfig(),
    ));
  }
}
