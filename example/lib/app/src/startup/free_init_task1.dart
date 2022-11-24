import 'package:common/common/startup/flutter_startup.dart';

import 'package:common/common/log/a_logger.dart';
import 'package:flutter/material.dart';

class FreeInitTask1 extends FlutterStartup {
  static String key = 'FreeInitTask1';

  @override
  Future<bool> create(BuildContext context) {
    logW("FreeInitTask1 startup..");
    return Future.value(true);
  }

  @override
  String get name => key;
}
