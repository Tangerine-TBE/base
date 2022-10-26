library network;

import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'dart:convert';

import 'status_code.dart';

// parts
part 'dio_config.dart';

part './logger.dart';

part './a_response.dart';

enum Method { get, post, put, delete }

/// 封裝 - 初始化入口install()
abstract class DioClient {
  late DioOptions config = loadOptions();

  late Dio _dio;

  DioOptions loadOptions();

  /// 初始化_dio
  void install() {
    BaseOptions options = DioOptions(host: config.host);

    _dio = Dio(options);
    _dio.interceptors
      ..add(LogInterceptor(requestBody: true, responseBody: true))
      ..addAll(config.interceptors ?? []);
    //SSL证书
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      //忽略SSL验证--待封装SSL证书
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      //代理
      if (config.proxy != null) {
        client.findProxy = (uri) => "PROXY ${config.proxy}:${config.proxyPort}";
      }
    };
  }

  /// 单文件上传
  Future<Response<String>> uploadFile({
    required String url,
    required String formDataKey,
    required String filePath,
    String? fileName,
    Function(int sent, int total)? progressListener,
  }) async {
    FormData formData = FormData.fromMap({
      formDataKey: await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    });
    return await _dio.post(
      url,
      data: formData,
      onSendProgress: progressListener,
    );
  }

  /// 多文件上传
  Future<Response<String>> uploadFiles({
    required String url,
    required String formDataKey,
    required List<String> filePaths,
    Function(int sent, int total)? progressListener,
  }) async {
    FormData formData = FormData.fromMap({
      formDataKey: filePaths.map((filepath) async {
        return await MultipartFile.fromFile(filepath);
      }).toList(),
    });
    return await _dio.post(
      url,
      data: formData,
      onSendProgress: progressListener,
    );
  }

  Future<Response<String>> requestOnFuture({
    required String path,
    Map<String, dynamic>? params,
    Method method = Method.get,
    CancelToken? cancelToken,
  }) async {
    Response<String> response =
        await _dioRequest(path, params, method, cancelToken);
    // var json = jsonDecode(response.data!);
    // var code = response.statusCode;
    // var msg = response.statusMessage;
    return response;
  }

  ///dio--request请求
  Future<Response<String>> _dioRequest(
    String path,
    Map<String, dynamic>? params,
    Method method,
    CancelToken? cancelToken,
  ) async {
    Response<String> response;
    switch (method) {
      case Method.get:
        response = await _dio.get(
          path,
          queryParameters: params,
          cancelToken: cancelToken,
        );
        break;
      case Method.post:
        response = await _dio.post(
          path,
          data: params,
          cancelToken: cancelToken,
        );
        break;
      case Method.put:
        response = await _dio.put(
          path,
          data: params,
          cancelToken: cancelToken,
        );
        break;
      default:
        response = await _dio.post(
          path,
          data: params,
          cancelToken: cancelToken,
        );
        break;
    }
    return response;
  }
}
