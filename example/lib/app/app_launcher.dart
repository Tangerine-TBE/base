import 'package:example/app/src/my_app.dart';
import 'package:flutter/cupertino.dart';

import '../app_base/config/route_config.dart';
import 'launcher/strategy/base_sample_launcher_strategy.dart';

/// app启动器
class AppLauncher {
  /// 启动 - 通过启动策略启动
  static void launch(
    BaseSampleLauncherStrategy launcherStrategy,
  ) {
    runApp(MyApp(
      launcherStrategy: launcherStrategy,
      route: RouteConfig(),
    ));
  }
}
