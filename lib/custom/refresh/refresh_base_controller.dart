import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:dx_plugin/dx_plugin.dart';

abstract class BaseRefreshController extends CacheController
    with DisposeController {
  ///base底部控件config--list使用
  static late FooterConfig? baseFooterConfig;

  FooterConfig? get getBaseFoot => baseFooterConfig;

  static set baseFooter(FooterConfig footerConfig) =>
      baseFooterConfig = footerConfig;

  ///base头部部控件Widget
  static late Widget? baseHeaderWidget;

  Widget? get getBaseHeader => baseHeaderWidget;

  static set baseHeader(Widget? baseHeader) => baseHeaderWidget = baseHeader;

  final String url;
  final DXHttp http;
  final bool isList;
  Map<String, dynamic> params;
  RequestMethod method;
  final String? emptyStr;
  final String? emptyUrl;
  final int emptyCode;
  late RefreshController refreshController;
  final bool isNeedCache;
  final Widget? childHeader;

  BaseRefreshController({
    required this.url,
    required this.http,
    required this.isList,
    this.params = const {},
    this.method = RequestMethod.GET,
    this.emptyStr,
    this.emptyUrl,
    this.emptyCode = 400,
    this.isNeedCache = false,
    this.childHeader,
  }) {
    refreshController = RefreshController();
  }

  ///下拉刷新
  void refresh() {
    cacheRefresh();
    refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    refreshController.dispose();
  }

  Stream<ResponseBean> getStream() {
    return http.requestOnStream(
      path: url,
      params: params,
      method: method,
      isNeedCache: isNeedCache,
      isErrorToast: false,
    );
  }
}
