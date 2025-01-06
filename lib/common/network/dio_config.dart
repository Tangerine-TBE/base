part of network;

class DioConfig extends BaseOptions {
  DioConfig({
    required this.host,
    this.proxy,
    this.proxyPort,
    this.header,
    this.interceptors,
    this.pem,
    this.pemFilepath,
  }) : super(
          baseUrl: host,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: header,
        );

  final String host;
  final String? proxy;
  final String? proxyPort;
  final Map<String, dynamic>? header;
  final List<Interceptor>? interceptors;
  final String? pem; // https requires pem string or ↓
  final String? pemFilepath; // pem file path in project for https
}
