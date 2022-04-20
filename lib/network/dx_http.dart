import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dx_plugin/network/dx_http_config.dart';
import 'package:dx_plugin/utils/dx_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:dx_plugin/dx_plugin.dart' as DX;

typedef OnSuccess = Function(Map<String, dynamic> map);
typedef OnError = Function(String msg, int code);

enum RequestMethod { GET, POST, PUT, DELETE, DOWNLOAD, FORM_DATA }

///Stream方式返回对象
class ResponseBean {
  bool isSuccess;
  bool isCache;
  Map<String, dynamic> map;

  ResponseBean(this.isSuccess, this.map, {this.isCache = false});
}

///BaseHttp：可存在多个不同API，各自继承抽象类，initConfig()返回NetWorkConfig 各API参数配置。(缺Future方式)
///callBack/stream -> _request
///缓存规则：K-V缓存数据。key =_networkCacheKey,value<Map>;
///Map-key=Url+params key排序后 key+value.默认总共缓存五十条数据
abstract class DXHttp {
  final String _networkCacheKey = "network_cache";
  String logTitle = "--------DXHttp--------";

  late DXHttpConfig _netWorkConfig;

  DXHttpConfig initConfig();

  /// 加载弹窗
  void showLoading() {}

  void dismissLoading() {}

  ///定制错误处理
  void defaultError(String msg, int code, bool isErrorToast, OnError? onError,bool isNeedBack);

  CancelToken _cancelToken = CancelToken();

  late Dio _dio;

  ///debug打印日志
  void _debugPrintLog(String log) {
    if (_netWorkConfig.isDebugPrint) debugPrint("$logTitle$log");
  }

  ///初始化
  void init() {
    _debugPrintLog('init');
    _netWorkConfig = initConfig();
    //全局参数
    BaseOptions options = BaseOptions(
        connectTimeout: _netWorkConfig.connectTimeout,
        receiveTimeout: _netWorkConfig.receiveTimeout,
        sendTimeout: _netWorkConfig.sendTimeout,
        headers: _netWorkConfig.baseHeader,
        baseUrl: _netWorkConfig.baseUrl);
    _dio = Dio(options);
    //log输出
    if (_netWorkConfig.isPrintLog)
      _dio.interceptors
        ..add(LogInterceptor(requestBody: true, responseBody: true));
    //拦截器
    if (_netWorkConfig.interceptors.length > 0)
      _dio.interceptors..addAll(_netWorkConfig.interceptors);
    //SSL证书
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      //忽略SSL验证--待封装SSL证书
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      //代理
      if (_netWorkConfig.isProxy)
        client.findProxy = (uri) {
          return "PROXY ${_netWorkConfig.proxyAddress}:${_netWorkConfig.proxyHost}";
        };
    };
  }

  ///callBack请求，onSuccess必传，默认post+show loading ,
  void requestOnCallBack(
      {required String path,
      required OnSuccess onSuccess,
      Map<String, dynamic>? params,
      RequestMethod method = RequestMethod.POST,
      OnError? onError,
      Map<String, dynamic> header = const {},
      bool isShowLoading = true,
      bool isErrorToast = true,
      bool isNeedBack = false,
      FormData? formData,
      CancelToken? cancelToken}) async {
    var baseUrl = _dio.options.baseUrl;
    if (baseUrl.isNullOrEmpty) _dio.options.baseUrl = _netWorkConfig.baseUrl;

    ///post 默认show loading
    if (isShowLoading) showLoading();
    var map = await _request(path,
        params: params,
        method: method,
        header: header,
        formData: formData,
        cancelToken: cancelToken);
    _debugPrintLog('request=$map');
    if (isShowLoading) dismissLoading(); //dismiss
    ResponseBean bean = _parseResponse(map);
    if (bean.isSuccess) {
      onSuccess(bean.map);
      return;
    }
    _onError(bean.map, onError: onError, isErrorToast: isErrorToast,isNeedBack: isNeedBack);
  }

  ///Stream请求，默认 get + cache ,配合StreamBuild 使用
  Stream<ResponseBean> requestOnStream(
      {required String path,
      Map<String, dynamic>? params,
      RequestMethod method = RequestMethod.GET,
      Map<String, dynamic> header = const {},
      bool isNeedCache = true,
      bool isErrorReturn = true,
      bool isNeedBack = true,
      bool isErrorToast = true,
      CancelToken? cancelToken}) async* {
    ///get 默认添加缓存
    String? cacheKey;
    Map<String, dynamic>? cacheMap;
    if (isNeedCache) {
      cacheKey = _getCacheKey(path, params: params);
      cacheMap = _getCacheMap();
      if (cacheMap[cacheKey] != null) {
        _debugPrintLog('get_cache');
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
      _onError(bean.map, isErrorToast: isErrorToast,isNeedBack: isNeedBack);
      //onError是否返回Bean
      if (isErrorReturn) yield bean;
    }
  }

  ///请求方法：callBack/stream调用，暂实现:GET、POST、POST_FORM_DATA,PUT
  ///method==post,formData不为空为表单上传
  ///return:map
  Future<Map<String, dynamic>> _request(String path,
      {Map<String, dynamic>? params,
      RequestMethod method = RequestMethod.GET,
      Map<String, dynamic> header = const {},
      FormData? formData,
      CancelToken? cancelToken}) async {
    if (header.length > 0) _dio.options.headers.addAll(header);
    //reset接收时间，下载时设为0,不限制。
    if (_dio.options.receiveTimeout != _netWorkConfig.receiveTimeout) {
      _dio.options.receiveTimeout = _netWorkConfig.receiveTimeout;
    }
    Map<String, dynamic> map = {};
    try {
      do {
        map = await _dioRequest(
            path, params, method, cancelToken ?? _cancelToken);
      } while (isRequestAgain(map));
    } catch (e) {
      _setCatchError(e, map);
    }
    return map;
  }

  ///是否需要重新请求
  bool isRequestAgain(Map<String, dynamic> map) {
    return false;
  }

  ///dio--request请求
  Future<Map<String, dynamic>> _dioRequest(
    String path,
    Map<String, dynamic>? params,
    RequestMethod method,
    CancelToken cancelToken, {
    FormData? formData,
  }) async {
    Response<String> response;
    switch (method) {
      case RequestMethod.GET:
        response = await _dio.get(path,
            queryParameters: params, cancelToken: cancelToken);
        break;
      case RequestMethod.POST:
        if (formData != null) {
          response =
              await _dio.post(path, data: formData, cancelToken: cancelToken);
        } else {
          response =
              await _dio.post(path, data: params, cancelToken: cancelToken);
        }
        break;
      case RequestMethod.PUT:
        response = await _dio.put(path, data: params, cancelToken: cancelToken);
        break;
      default:
        response =
            await _dio.post(path, data: params, cancelToken: cancelToken);
        break;
    }
    _debugPrintLog('success');
    return jsonDecode(response.data!);
  }

  ResponseBean _parseResponse(Map<String, dynamic> map) {
    var successCode = _netWorkConfig.successCode;
    var code = map[_netWorkConfig.codeStr];
    return ResponseBean(code == successCode, map);
  }

  ///错误处理
  void _onError(Map<String, dynamic> map,
      {OnError? onError, bool isErrorToast = true,bool isNeedBack = false}) {
    debugPrint("_onError==========${onError == null}");
    var msg = (map[_netWorkConfig.msgStr] as String?) ?? '';
    defaultError(msg, map[_netWorkConfig.codeStr], isErrorToast, onError,isNeedBack);
  }

  ///设置catch捕捉到的dioError,config.getErrorMsg 处理
  void _setCatchError(dynamic e, Map<String, dynamic> map) {
    var config = _netWorkConfig;
    String msg = '';
    int code;
    if (!e is DioError) {
      msg = '';
      code = -1;
    } else {
      e as DioError;
      _debugPrintLog('catch_error,type=${e.type}\n msg=${e.message}');
      if (config.onCatchError != null) {
        var tuple = config.onCatchError!.call(e.type);
        code = tuple.item1;
        msg = tuple.item2;
      } else {
        code = -1;
        switch (e.type) {
          case DioErrorType.cancel:
            msg = "請求取消";
            break;
          case DioErrorType.connectTimeout:
            msg = "連接超時";
            break;
          case DioErrorType.sendTimeout:
            msg = "請求超時";
            break;
          case DioErrorType.receiveTimeout:
            msg = "響應超時";
            break;
          case DioErrorType.response:
            msg = "響應报文异常";
            break;
          case DioErrorType.other:
            msg = "網絡異常";
            break;
        }
      }
    }
    map = {_netWorkConfig.codeStr: code, _netWorkConfig.msgStr: msg};
  }

  ///缓存机制：默认Get请求配合StreamBuild使用，只存success请求，map缓存，默认50条
  ///存缓存数据
  void _setCache(
    Map<String, dynamic> cacheMap,
    String paramsStr,
    Map<String, dynamic> map,
  ) {
    var kvKey = _networkCacheKey + _netWorkConfig.baseUrl;
    if (cacheMap.containsKey(paramsStr)) cacheMap.remove(paramsStr);
    if (cacheMap.length > _netWorkConfig.cacheSum)
      cacheMap.remove(cacheMap.keys.first);
    cacheMap[paramsStr] = map;
    DX.GetStorage().write(kvKey, jsonEncode(cacheMap));
  }

  ///获取缓存map
  Map<String, dynamic> _getCacheMap() {
    var storage = DX.GetStorage();
    var kvKey = _networkCacheKey + _netWorkConfig.baseUrl;
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
      //排除忽略key
      _netWorkConfig.ignoreKey.forEach((k) {
        if (kList.contains(k)) kList.remove(k);
      });
      kList.sort();
      kList.forEach((key) {
        paramsStr += key += params[key].toString();
      });
    }
    return paramsStr;
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
      var map = {_netWorkConfig.msgStr: "網絡錯誤", _netWorkConfig.codeStr: 404};
      _onError(map, onError: onError);
    }
  }
}
