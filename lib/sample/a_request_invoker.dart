
import 'package:common/network/dio_client.dart';

/// 举例如何实现DiaClient
/// 属于项目业务相关
/// 主要关注host、代理、header、拦截器的注入
class RequestInvoker extends DioClient {
  static RequestInvoker? _instance;

  factory RequestInvoker.get() => _getInstance();

  static _getInstance() {
    return _instance ??= RequestInvoker._init();
  }

  RequestInvoker._init() {
    super.install();
  }

  @override
  DioOptions loadOptions() => DioOptions(
        host: "Url.getUrl",
        proxy: "_getProxyAddress",
        proxyPort: "_getProxyPort",
        // header: {
        //   "signType": "MD5",
        //   "clientId": "2",
        // },
        // interceptors: [SignInterceptor()],
      );
}
