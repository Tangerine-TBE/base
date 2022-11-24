import 'dart:async';

import 'package:common/common/log/a_logger.dart';
import 'package:common/common/startup/flutter_startup.dart';

class PrivacyTask extends FlutterStartup {
  static String key = 'PrivacyTask';

  @override
  String get name => key;

  @override
  bool create() {
    // TODO show privacy dialog
    logW('show privacy confirm dialog and pressed yes..');
    return true;
  }

  @override
  int get priority => 999;
}
