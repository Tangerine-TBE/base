import 'package:get_storage/get_storage.dart';

class Storage {
  static Future<void> init() async {
    await GetStorage.init();
  }
}
