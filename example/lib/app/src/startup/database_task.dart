import 'package:common/common/log/a_logger.dart';
import 'package:common/common/startup/flutter_startup.dart';

import 'privacy_task.dart';

class DataBaseTask extends FlutterStartup {
  static String key = 'DataBaseTask';

  @override
  String get name => key;

  @override
  Future<bool> create() async {
    logW("start up DataBaseTask...");
    await Future.delayed(const Duration(seconds: 1));
    return Future.value(true);
  }

  @override
  String? get dependency => PrivacyTask.key;

}
