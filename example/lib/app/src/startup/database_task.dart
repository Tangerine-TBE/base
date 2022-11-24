import 'package:common/common/log/a_logger.dart';
import 'package:common/common/startup/flutter_startup.dart';

import 'privacy_task.dart';

class DataBaseTask extends FlutterStartup {
  static String key = 'DataBaseTask';

  @override
  String get name => key;

  @override
  bool create() {
    logW("start up DataBaseTask...");
    return true;
  }

  @override
  String? get dependency => PrivacyTask.key;

}
