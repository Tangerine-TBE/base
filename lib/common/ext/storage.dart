import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<SharedPreferences> init() async {
    return await SharedPreferences.getInstance();
  }
}
