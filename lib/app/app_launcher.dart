import 'package:common/launcher/launcher_strategy.dart';
import 'package:flutter/cupertino.dart';
import 'package:sample/app/my_app.dart';

/// app启动器
class AppLauncher {
  /// 启动 - 通过启动策略启动
  static void launch(LauncherStrategy launcherStrategy) {
    runApp(MyApp(launcherStrategy: launcherStrategy));
  }
}
