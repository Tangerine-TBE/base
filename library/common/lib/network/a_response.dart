part of network;

/// 請求結果處理
/// 目前針對dxHttp的ResponseBean進行數據格式轉換
/// 未來可以替換成dio本身
class AResponse<T> {
  AResponse(this.data, {this.code, this.message});

  T? data;

  int? code;

  String? message;

  // 判空
  bool get isEmpty => data == null;

  // 是否請求成功
  bool get isSuccess => code == 200;

  /// 對dio的Response進行JSON轉換
  static Future<AResponse<T>> convert<T>(
    Future<Response<String>> Function() futureTask,
    T Function(dynamic data) onResponse,
  ) async {
    try {
      return await futureTask().then(
        (responseBean) => handleDioResponse(responseBean, onResponse),
      );
    } catch (error) {
      logger.e("---- Response.convert() ====> catch request error: $error");
      if (error is DioError) {
        int code = 0;
        String msg = "";
        switch (error.type) {
          case DioErrorType.cancel:
            msg = "請求取消";
            break;
          case DioErrorType.connectTimeout:
            code = TIME_OUT;
            msg = "連接超時";
            break;
          case DioErrorType.sendTimeout:
            code = TIME_OUT;
            msg = "請求超時";
            break;
          case DioErrorType.receiveTimeout:
            code = TIME_OUT;
            msg = "響應超時";
            break;
          case DioErrorType.response:
            msg = "響應报文异常";
            break;
          case DioErrorType.other:
            code = TIME_OUT;
            msg = "網絡異常";
            break;
        }
        return AResponse(null, code: code, message: msg);
      }
      return AResponse(null, message: error.toString());
    }
  }

  /// 處理ResponseBean的map數據
  static AResponse<T> handleDioResponse<T>(
    Response<String> dioResponse,
    T Function(dynamic data) onResponse,
  ) {
    Map<String, dynamic> map = jsonDecode(dioResponse.data!);
    var code = map["code"];
    var message = map["message"];
    var data = map["data"]; // data 可能是List 或 Object 或 基本數據類型（bool）
    logger.w(
        ("--- 注意response.code: ${dioResponse.statusCode}, response.message: ${dioResponse.statusMessage}"));
    logger.i("---- Evan =====> response: code[$code], || "
        "msg:[$message] || ,\n "
        "${const JsonEncoder.withIndent('  ').convert(data)}");
    return AResponse(
      onResponse.call(data),
      code: code,
      message: message,
    );
  }
}
