import 'package:get_storage/get_storage.dart';

///抽取以便更換三方庫
class SaveUtils {
  Future<bool> init() => GetStorage.init();

  static void setInt(String key, int value) {
    _setValue(key, value);
  }

  static void setString(String key, String value) {
    _setValue(key, value);
  }

  static void setBool(String key, bool value) {
    _setValue(key, value);
  }

  static void setIntList(String key, List<int> value) {
    _setValue(key, value);
  }

  static List<int>? getIntList(String key) {
    var value = _getValue<List>(key);
    if (value == null) return null;
    return value.map<int>((e) => e as int).toList();
  }

  ///保存數據
  static void _setValue(String key, dynamic value) {
    GetStorage().write(key, value);
  }

  static int? getInt(String key) {
    return _getValue<int>(key);
  }

  static String? getString(String key, {String? defValue}) {
    var value = _getValue<String>(key);
    if (value == null && defValue != null) return defValue;
    return _getValue<String>(key);
  }

  static bool? getBool(String key, {bool? defValue}) {
    var value = _getValue<bool>(key);
    if (value == null && defValue != null) return defValue;
    return value;
  }

  ///讀取數據
  static T? _getValue<T>(String key) {
    return GetStorage().read<T>(key);
  }

  static void removeKey(String key) {
    GetStorage().remove(key);
  }
}
