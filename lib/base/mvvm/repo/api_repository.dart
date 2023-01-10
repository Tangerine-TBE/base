library api_service;

import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../common/network/dio_client.dart';
import 'dio_proxy.dart';

// beans
part '../model/data_holder.dart';

part '../model/local_model.dart';

/// 网络请求隔离层，目的是不暴露诸如TesoHttp、Http具体的请求实现给上层业务
/// BaseRepo
abstract class ApiRepository {
  late final CancelToken _globalCancelToken = CancelToken();

  abstract DioProxy proxy;

  /// 代理請求
  Future<AResponse<T>> requestOnFuture<T>(
    // 路由
    String path, {
    Method method = Method.get,
    Map<String, dynamic> params = const {},
    String? contentType,
    Function(dynamic data)? format,
  }) async {
    Options? options;
    if (contentType?.isNotEmpty == true) {
      // contentType can using dio class <Headers> like: Headers.formUrlEncodedContentType
      options = Options(contentType: contentType);
    }
    var futureTask = proxy.requestOnFuture(
      path: path,
      method: method,
      params: params,
      options: options,
      cancelToken: _globalCancelToken,
    );

    return AResponse.convert<T>(
      () => futureTask,
      (data) => format?.call(data),
    );
  }

  /// 单文件上传 bytes形式
  Future<AResponse<F>> uploadFileBytes<F>({
    required String url,
    required String formDataKey,
    required ByteData byteData,
    Map<String, dynamic> body = const {},
    Function(dynamic data)? format,
    String? filename,
    Function(int sent, int total)? progressListener,
  }) async {
    var futureTask = proxy.uploadFileBytes(
      url: url,
      formDataKey: formDataKey,
      byteData: byteData,
      filename: filename,
      body: body,
      progressListener: progressListener,
    );
    return AResponse.convert<F>(
      () => futureTask,
      (data) => format?.call(data),
    );
  }

  /// 单文件上传
  Future<AResponse<F>> uploadFile<F>({
    required String url,
    required String formDataKey,
    required String filePath,
    String? fileName,
    Function(dynamic data)? format,
    Function(int sent, int total)? progressListener,
  }) async {
    var futureTask = proxy.uploadFile(
      url: url,
      formDataKey: formDataKey,
      filePath: filePath,
      progressListener: progressListener,
    );

    return AResponse.convert<F>(
      () => futureTask,
      (data) => format?.call(data),
    );
  }

  /// 多文件上传
  Future<AResponse<F>> uploadFiles<F>({
    required String url,
    required String formDataKey,
    required List<String> filePaths,
    Function(dynamic data)? format,
    Function(int sent, int total)? progressListener,
  }) async {
    var futureTask = proxy.uploadFiles(
      url: url,
      formDataKey: formDataKey,
      filePaths: filePaths,
      progressListener: progressListener,
    );
    return AResponse.convert<F>(
      () => futureTask,
      (data) => format?.call(data),
    );
  }

  void cancelAll() {
    _globalCancelToken.cancel();
  }
}
