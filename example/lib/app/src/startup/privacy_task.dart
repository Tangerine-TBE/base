import 'dart:async';

import 'package:common/common/log/a_logger.dart';
import 'package:common/common/startup/flutter_startup.dart';

class PrivacyTask extends FlutterStartup {
  static String key = 'PrivacyTask';

  @override
  String get name => key;

  @override
  Future<bool> create() async {
    // TODO show privacy dialog
    logW('start up $key');
    await Future.delayed(const Duration(seconds: 3));
    return Future.value(true);
  }
}
