import 'package:common/common/widget/loading/g_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/log/a_logger.dart';
import '../../../common/network/dio_client.dart';
import '../../../common/network/status_code.dart';
import '../../helper/navigation_helper.dart';
import '../repo/api_repository.dart';

/// Controller基類
/// BaseVM
abstract class BaseViewModel extends GetxController
    with WidgetsBindingObserver, NavigationHelper {
  /// 頁面狀態 - loading
  void showLoading() => GLoading.instance.showLoading();

  /// 頁面狀態 - 空
  void showEmpty();

  /// 頁面狀態 - 錯誤
  void showError(String? message);

  /// 401 403 token過期/更新，需要重新登錄
  void handleUnAuthorizedError();

  /// 頁面狀態 - 重置
  void resetShow() {}

  /// 頁面狀態 - loading、空、錯誤均關閉
  void dismiss() => GLoading.instance.dismiss();

  /// 生命週期 - onResumed 桌面恢復
  void onResumed() {}

  /// 生命週期 - onPause 退到桌面
  void onPause() {}

  /// 生命週期 - onInit
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  /// 生命週期 - onClose
  @override
  void onClose() {
    dismiss();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // 從桌面恢復
        onResumed();
        break;
      case AppLifecycleState.inactive:
        // 退出到桌面
        break;
      case AppLifecycleState.paused:
        // 緊跟inactive之後
        onPause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  /// 執行future
  Future<T?> apiLaunch<T>(
    Future<AResponse<T>> Function() futureTask, {
    bool enableLoading = true,
  }) async {
    resetShow();
    if (enableLoading) showLoading();
    AResponse<T> response = await futureTask();
    if (enableLoading) dismiss();

    // status - error
    if (!response.isSuccess) {
      _handleResponseError(response);
      return null;
    }

    // status - empty
    var data = response.data;
    if (data is DataHolder) {
      if (data.isEmpty()) showEmpty();
    } else if (response.isEmpty) {
      showEmpty();
    }

    return response.data;
  }

  /// 當需要多個請求同時發出時使用
  /// 如：
  ///     apiAsync(() async {
  ///        var r1 = await mineService.getR1();
  ///        var r2 = await mineService.getR2();
  ///        var r3 = await mineService.getR3();
  ///     });
  void apiAsync(Future Function() futureTask) async {
    resetShow();
    showLoading();
    await futureTask();
    dismiss();
  }

  /// 錯誤代碼處理
  void _handleResponseError(AResponse response) {
    logE(
      "----- base_controller._handleResponseError(): code: ${response.code}, message: ${response.message}",
    );

    switch (response.code) {
      case UNAUTHORIZED:
      case FORBIDDEN:
        handleUnAuthorizedError();
        break;
      case TIME_OUT:
        showError(response.message);
        break;
      case SERVER_ERROR:
        _handleServerError(response.message);
        break;
      default:
        break;
    }
  }

  /// 500 服務器錯誤
  void _handleServerError(String? msg) {
    // toast is enough
    showError("服務器發生錯誤:500");
  }
}
