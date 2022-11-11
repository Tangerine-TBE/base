import 'package:get/get.dart';

mixin NavigationHelper {
  /// 普通跳轉
  void navigateTo(
    String route, {
    dynamic args,
  }) {
    intent() {
      Get.toNamed(route, arguments: args);
    }

    intent.call();
  }

  /// 帶頁面數據回調跳轉
  Future<R?> navigateForResult<R>(
    String route, {
    dynamic args,
    Function(R? result)? onResult,
  }) {
    var result = Get.toNamed(route, arguments: args)?.then<R>(
      (value) => onResult?.call(value),
    );
    return Future.value(result);
  }

  /// 獲取Get傳來的arguments
  R? getArgs<R>() => Get.arguments;

  /// 設置回調的結果數據
  void setResult<T>(T data) {
    Get.back(result: data);
  }

  /// 關閉當前頁面
  void finish() {
    Get.back();
  }
}
