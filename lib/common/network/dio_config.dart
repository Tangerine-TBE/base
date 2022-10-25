part of network;

class DioOptions extends BaseOptions {
  DioOptions({
    required this.host,
    this.proxy,
    this.proxyPort,
    this.header,
    this.interceptors,
  }) : super(
          baseUrl: host,
          connectTimeout: 30 * 1000,
          receiveTimeout: 30000,
          sendTimeout: 30000,
          headers: {
            "signType": "MD5",
            "clientId": "2",
          },
        );

  final String host;
  final String? proxy;
  final String? proxyPort;
  final Map<String, dynamic>? header;
  final List<Interceptor>? interceptors;
}
