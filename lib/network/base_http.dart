import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:dx_plugin/dx_plugin.dart' as DX;

typedef OnSuccess = Function(Map<String, dynamic> map);
typedef OnError = Function(String msg, int code);

enum RequestMethod { GET, POST, PUT, DELETE, DOWNLOAD, FORM_DATA }

class NetWorkConfig {
  Map<String, String> baseHeader;
  List<Interceptor> interceptors;
  int successCode; //成功code
  int listEmptyCode; //请求列表为空Code
  int connectTimeout; //连接超时时间
  int receiveTimeout; //接收超时时间
  int sendTimeout; //发送数据超时时间
  bool isPrintLog; //是否输出日志
  bool isIgnoreSSL; //是否忽略ssl验证
  bool isProxy; //是否设置代理
  String proxyAddress; //代理地址
  String baseUrl;
  String msgStr;
  String codeStr;

  NetWorkConfig(
    this.baseUrl, {
    this.successCode = 200,
    this.listEmptyCode = 400,
    this.baseHeader = const {},
    this.interceptors = const [],
    this.connectTimeout = 30000,
    this.receiveTimeout = 30000,
    this.sendTimeout = 30000,
    this.isPrintLog = false,
    this.isIgnoreSSL = true,
    this.isProxy = true,
    this.proxyAddress = "",
    this.msgStr = "msg",
    this.codeStr = "code",
  });

  OnError defaultError = (msg, code) {
    //showToast
  };
}

class ResponseBean {
  bool isSuccess;
  bool isCache;
  Map<String, dynamic> map;

  ResponseBean(this.isSuccess, this.map, {this.isCache = false});
}

///example:
/// class MerHttp extends BaseHttp {
///   static bool ignoreSign = false;
///
///   static MerHttp _instance = MerHttp._init();
///
///   factory MerHttp.instance() => _instance;
///
///   MerHttp._init() {
///     super.init();
///   }
///
///   NetWorkConfig initConfig() => NetWorkConfig('http://www.baidu.con',
///     isProxy: true,
///     proxyAddress: "192.168.x.x",
///     successCode: 200,
///     codeStr: 'code',
///     msgStr: "message",
///     isPrintLog: false,
///     baseHeader: {
///       "signType": "MD5",
///       "clientId": "1",
///     },);
/// }
///
///BaseHttp：可存在多个不同API，各自继承抽象类，initConfig()返回NetWorkConfig 各API参数配置。
abstract class BaseHttp {
  static const NETWORK_CACHE = "network_cache";

  late NetWorkConfig mNetWorkConfig;

  NetWorkConfig initConfig();

  /// 加载弹窗
  void showLoading() {}

  void dismissLoading() {}

  ///定制错误处理
  void customError(String msg, int code, bool isErrorToast) {}

  ///添加公共请求头
  Map<String, dynamic> addPublicHeader();

  CancelToken _cancelToken = CancelToken();

  late Dio _dio;

  init() {
    mNetWorkConfig = initConfig();
    //全局参数
    BaseOptions options = BaseOptions(
        connectTimeout: mNetWorkConfig.connectTimeout,
        receiveTimeout: mNetWorkConfig.receiveTimeout,
        sendTimeout: mNetWorkConfig.sendTimeout,
        headers: mNetWorkConfig.baseHeader,
        baseUrl: mNetWorkConfig.baseUrl);
    _dio = Dio(options);
    //log输出
    if (mNetWorkConfig.isPrintLog)
      _dio.interceptors
        ..add(LogInterceptor(requestBody: true, responseBody: true));
    //拦截器
    if (mNetWorkConfig.interceptors.length > 0)
      _dio.interceptors..addAll(mNetWorkConfig.interceptors);
    //SSL证书
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      if (mNetWorkConfig.isIgnoreSSL)
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      //代理
      if (mNetWorkConfig.isProxy)
        client.findProxy = (uri) {
          return "PROXY ${mNetWorkConfig.proxyAddress}";
        };
    };
  }

  ///简易下载文件，待封装
  void downFile(String path, String savePath, OnSuccess onSuccess,
      {ProgressCallback? onReceiveProgress, OnError? onError}) async {
    try {
      _dio.options.receiveTimeout = 0;
      var response = await _dio.download(path, savePath,
          onReceiveProgress: onReceiveProgress);
      if (response.statusCode == 200) {
        onSuccess({});
      } else if (onError != null) {
        onError('下载失败', 500);
      }
    } catch (e) {
      print("network_error");
      print("${e.toString()}");
      var map = {mNetWorkConfig.msgStr: "網絡錯誤", mNetWorkConfig.codeStr: 404};
      _onError(map, onError: onError);
    }
  }

  ///callBack请求，onSuccess必传，默认post+show loading ,
  void requestOnCallBack(String path, OnSuccess onSuccess,
      {Map<String, dynamic>? params,
      RequestMethod method = RequestMethod.POST,
      OnError? onError,
      Map<String, dynamic> header = const {},
      bool isShowLoading = true,
      bool isNeedSave = false,
      bool isErrorToast = true,
      FormData? formData,
      CancelToken? cancelToken}) async {
    var baseUrl = _dio.options.baseUrl;
    if (baseUrl.isNullOrEmpty) _dio.options.baseUrl = mNetWorkConfig.baseUrl;

    ///post 默认show loading
    if (isShowLoading) showLoading();
    var map = await _request(path,
        params: params,
        method: method,
        header: header,
        formData: formData,
        cancelToken: cancelToken);
    print("map=$map");
    if (isShowLoading) dismissLoading(); //dismiss
    ResponseBean bean = _parseResponse(map);
    if (bean.isSuccess) {
      if (isNeedSave) {
        var cacheKey = _getCacheKey(path, params: params);
        var cacheMap = _getCacheMap();
        _setCache(cacheMap, cacheKey, map);
      }
      onSuccess(bean.map);
      return;
    }
    _onError(bean.map, onError: onError, isErrorToast: isErrorToast);
  }

  ///Stream请求，默认 get + cache ,配合StreamBuild 使用
  Stream<ResponseBean> requestOnStream(String path,
      {Map<String, dynamic>? params,
      RequestMethod method = RequestMethod.GET,
      Map<String, dynamic> header = const {},
      bool isNeedCache = true,
      bool isErrorReturn = true,
      bool isErrorToast = true,
      CancelToken? cancelToken}) async* {
    ///get 默认添加缓存
    String? cacheKey;
    Map<String, dynamic>? cacheMap;
    if (isNeedCache) {
      cacheKey = _getCacheKey(path, params: params);
      cacheMap = _getCacheMap();
      if (cacheMap[cacheKey] != null) {
        debugPrint("cacheMap================");
        yield ResponseBean(true, cacheMap[cacheKey]);
      }
    }
    var map = await _request(path,
        params: params,
        method: method,
        header: header,
        cancelToken: cancelToken);

    ResponseBean bean = _parseResponse(map);
    if (bean.isSuccess) {
      if (isNeedCache) _setCache(cacheMap!, cacheKey!, map);
      yield bean;
    } else {
      _onError(bean.map, isErrorToast: isErrorToast);
      if (isErrorReturn) yield bean;
    }
  }

  ResponseBean _parseResponse(Map<String, dynamic> map) {
    var successCode = mNetWorkConfig.successCode;
    var code = map[mNetWorkConfig.codeStr];
    return ResponseBean(code == successCode, map);
  }

  ///错误处理
  void _onError(Map<String, dynamic> map,
      {OnError? onError, bool isErrorToast = true}) {
    debugPrint("_onError==========${onError == null}");
    var msg = map[mNetWorkConfig.msgStr] as String?;
    //resultErrorCode  統一處理
    customError(msg ?? "", map[mNetWorkConfig.codeStr], isErrorToast);
    if (!msg.isNullOrEmpty) {
      onError = onError ?? mNetWorkConfig.defaultError;
      onError(msg!, map[mNetWorkConfig.codeStr]);
    }
  }

  Future<Map<String, dynamic>> _request(String path,
      {Map<String, dynamic>? params,
      RequestMethod method = RequestMethod.GET,
      Map<String, dynamic> header = const {},
      FormData? formData,
      CancelToken? cancelToken}) async {
    if (header.length > 0) _dio.options.headers.addAll(header);
    _dio.options.receiveTimeout = mNetWorkConfig.receiveTimeout;
    _dio.options.headers.addAll(addPublicHeader());
    Map<String, dynamic> map;
    try {
      Response<String> response;
      switch (method) {
        case RequestMethod.GET:
          response = await _dio.get(path,
              queryParameters: params,
              cancelToken: cancelToken ?? _cancelToken);
          break;
        case RequestMethod.POST:
          if (formData != null) {
            response = await _dio.post(path,
                data: formData, cancelToken: cancelToken ?? _cancelToken);
          } else {
            response = await _dio.post(path,
                data: params, cancelToken: cancelToken ?? _cancelToken);
          }
          break;
        case RequestMethod.PUT:
          response = await _dio.put(path,
              data: params, cancelToken: cancelToken ?? _cancelToken);
          break;
        default:
          response = await _dio.post(path,
              data: params, cancelToken: cancelToken ?? _cancelToken);
          break;
      }
      debugPrint("success================");
      map = jsonDecode(response.data!);
    } catch (e) {
      ///error封装，待进一步完善，自定义code,在parseResponse()处理
      map = {mNetWorkConfig.codeStr: -1, mNetWorkConfig.msgStr: "未知错误"};
      if (e is DioError) _setErrorJson(e, map);
      print('2=${e.toString()}');
    }
    return map;
  }

  ///设置request error Json
  void _setErrorJson(DioError e, Map<String, dynamic> map) {
    // print("_setErrorJson========${e.type}");
    switch (e.type) {
      case DioErrorType.cancel:
        map[mNetWorkConfig.msgStr] = "請求取消";
        break;
      case DioErrorType.connectTimeout:
        map[mNetWorkConfig.msgStr] = "連接超時";
        break;
      case DioErrorType.sendTimeout:
        map[mNetWorkConfig.msgStr] = "請求超時";
        break;
      case DioErrorType.receiveTimeout:
        map[mNetWorkConfig.msgStr] = "響應超時";
        break;
      case DioErrorType.response:
        break;
      case DioErrorType.other:
        map[mNetWorkConfig.msgStr] = "網絡異常";
        break;
    }
  }

  ///缓存机制：默认Get请求配合StreamBuild使用，MMKV+Map缓存数据，只存success请求，默认50条
  ///存缓存数据
  void _setCache(
    Map<String, dynamic> cacheMap,
    String paramsStr,
    Map<String, dynamic> map,
  ) {
    var kvKey = NETWORK_CACHE + mNetWorkConfig.baseUrl;
    if (cacheMap.containsKey(paramsStr)) cacheMap.remove(paramsStr);
    if (cacheMap.length > 50) cacheMap.remove(cacheMap.keys.first);
    cacheMap[paramsStr] = map;
    DX.GetStorage().write(kvKey, jsonEncode(cacheMap));
  }

  ///获取缓存map
  Map<String, dynamic> _getCacheMap() {
    var storage = DX.GetStorage();
    var kvKey = NETWORK_CACHE + mNetWorkConfig.baseUrl;
    var cacheString = storage.read<String>(kvKey);
    Map<String, dynamic> cacheMap =
        cacheString.isNullOrEmpty ? {} : jsonDecode(cacheString!);
    return cacheMap;
  }

  ///获取缓存key
  String _getCacheKey(String url, {Map<String, dynamic>? params}) {
    var paramsStr = url;
    if (!params.isNullOrEmpty) {
      var kList = params!.keys.toList();
      kList.sort();
      kList.forEach((key) {
        paramsStr += key += params[key].toString();
      });
    }
    return paramsStr;
  }
}

