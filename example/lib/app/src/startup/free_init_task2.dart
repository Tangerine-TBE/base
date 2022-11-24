import 'package:common/common/startup/flutter_startup.dart';

import 'package:common/common/log/a_logger.dart';

class FreeInitTask2 extends FlutterStartup {
  static String key = 'FreeInitTask2';

  @override
  Future<bool> create() {
    logW("FreeInitTask2 startup..");
    return Future.value(true);
  }

  @override
  String get name => key;
}
