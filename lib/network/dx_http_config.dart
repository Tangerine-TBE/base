import 'package:dio/dio.dart';
import 'package:dx_plugin/dx_plugin.dart';
import 'package:tuple/tuple.dart';

class DXHttpConfig {
  final Map<String, String> baseHeader;
  final List<Interceptor> interceptors;
  final int successCode; //成功code
  final int listEmptyCode; //请求列表为空Code
  final int connectTimeout; //连接超时时间
  final int receiveTimeout; //接收超时时间
  final int sendTimeout; //发送数据超时时间
  final bool isPrintLog; //是否输出日志--拦截器
  final bool isDebugPrint; //是否输出日志--debugPrint
  final bool isProxy; //是否设置代理
  final String proxyAddress; //代理地址
  final String proxyHost; //代理地址
  final String baseUrl;
  final String msgStr;
  final String codeStr;
  final int cacheSum; //总共缓存多少条数据
  final List<String> ignoreKey; //缓存key忽略param-key
  final Tuple2<int, String> Function(DioErrorType type)? onCatchError;

  const DXHttpConfig(
    this.baseUrl, {
    this.successCode = 200,
    this.listEmptyCode = 400,
    this.baseHeader = const {},
    this.interceptors = const [],
    this.connectTimeout = 30000,
    this.receiveTimeout = 30000,
    this.sendTimeout = 30000,
    this.isPrintLog = false,
    this.isDebugPrint = true,
    this.isProxy = true,
    this.proxyAddress = "",
    this.proxyHost = "",
    this.msgStr = "msg",
    this.codeStr = "code",
    this.cacheSum = 50,
    this.ignoreKey = const [],
    this.onCatchError,
  });
}
