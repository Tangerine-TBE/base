import 'package:common/common/startup/flutter_startup.dart';

import 'package:common/common/log/a_logger.dart';

class FreeInitTask1 extends FlutterStartup {
  static String key = 'FreeInitTask1';

  @override
  Future<bool> create() {
    logW("FreeInitTask1 startup..");
    return Future.value(true);
  }

  @override
  String get name => key;
}
