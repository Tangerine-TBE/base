library api_service;

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
    Function(dynamic data)? format,
  }) async {
    var futureTask = proxy.requestOnFuture(
      path: path,
      method: method,
      params: params,
      cancelToken: _globalCancelToken,
    );

    return AResponse.convert<T>(
      () => futureTask,
      (data) => format?.call(data),
    );
  }

  void cancelAll() {
    _globalCancelToken.cancel();
  }
}
