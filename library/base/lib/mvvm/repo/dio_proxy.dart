import 'package:common/network/dio_client.dart';
import 'package:dio/dio.dart' as dio;

/// dio抽象代理
abstract class DioProxy extends DioClient {
  /// app defined api host
  abstract String host;

  /// app defined api proxy
  abstract String proxy;

  /// app defined api proxy port
  abstract String proxyPort;

  /// app defined api default headers
  Map<String, dynamic> loadDefaultHeader();

  /// app defined interceptors
  List<dio.Interceptor> loadInterceptors();

  @override
  DioOptions loadOptions() => DioOptions(
        host: host,
        proxy: proxy,
        proxyPort: proxyPort,
        header: loadDefaultHeader(),
        interceptors: loadInterceptors(),
        // header: {
        //   "signType": "MD5",
        //   "clientId": "2",
        //   "token": "",
        //   "typ": "JDBC",
        // },
        // interceptors: [SignInterceptor()],
      );
}
