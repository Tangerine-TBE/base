import 'package:example/app/src/app.dart';
import 'package:flutter/cupertino.dart';

import 'launcher/strategy/base_sample_launcher_strategy.dart';
import 'src/config/route_config.dart';

/// app启动器
class AppLauncher {
  /// 启动 - 通过启动策略启动
  static void launch(
    BaseSampleLauncherStrategy launcherStrategy,
  ) {
    runApp(App(
      launcherStrategy: launcherStrategy,
      route: RouteConfig(),
    ));
  }
}
