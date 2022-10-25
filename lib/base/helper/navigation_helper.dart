import 'package:get/get.dart';

mixin NavigationHelper {
  /// 普通跳轉
  void navigateTo(String route, {bool requiresLogin = false, dynamic args}) {
    intent() {
      Get.toNamed(route, arguments: args);
    }

    if (requiresLogin) {
      // _checkTokenDo(intent);
    } else {
      intent.call();
    }
  }

  /// 帶頁面數據回調跳轉
  void navigateForResult<R>(
      String route, {
        dynamic args,
        required Function(R? result) onResult,
      }) {
    Get.toNamed(route, arguments: args)?.then(
          (value) => onResult.call(value),
    );
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

// void _checkTokenDo(Function block) async {
//   if (_isLogin()) {
//     block.call();
//   } else {
//     bool isLogin = await Get.to(() => LoginRoute()) ?? false;
//     if (isLogin) block.call();
//   }
// }

// bool _isLogin() =>
//     !Url.token.isNullOrEmpty;
