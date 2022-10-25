part of api_service;

/// api数据转换和持有
/// api模型继承此类
/// T: 本地数据模型LocalModel
abstract class DataHolder<T> {
  List<T>? dataList;

  T? data;

  /// api數據轉換為本地bean（list）
  List<T>? convertList(
    dynamic map,
    T Function(dynamic data) format,
  ) {
    if (map is List) {
      if (map.isEmpty) return null;
      List<T>? list = [];
      for (var element in map) {
        list.add(format.call(element));
      }
      dataList = list;
    }
    return dataList;
  }

  /// api數據轉換為本地bean（obj）
  T? convert(
    dynamic json,
    T Function(dynamic data) format,
  ) {
    if (json == null) return null;
    data = format.call(json);
    return data;
  }

  /// 檢查空數據
  bool isEmpty();
}
