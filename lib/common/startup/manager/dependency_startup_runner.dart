import 'package:common/common/log/a_logger.dart';
import 'package:common/common/startup/startup.dart';

import 'startup_manager.dart';

/// 存在依赖关系的startup执行runner
class DependencyStartupRunner {
  DependencyStartupRunner(
    this.manager, {
    required this.startup,
  });

  final Startup startup;
  final StartupManager manager;

  void run() async {
    // 1. run self
    var startAt = DateTime.now();
    bool result = await startup.create();
    var endAt = DateTime.now();
    logV(
        "${startup.name} finish --> result: $result, time used: ${endAt.difference(startAt).inMilliseconds}");

    // 2. find children
    manager.notifyChildren(startup.name);
  }
}
