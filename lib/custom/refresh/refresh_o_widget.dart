import 'package:dx_plugin/custom/refresh/refresh_base_controller.dart';
import 'package:dx_plugin/dx_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// SmartRefresher->cacheStreamBuilder->child
///功能：缓存、空布局、网络布局(点击重连)、下拉刷新
class RefreshOController extends BaseRefreshController {
  final SuccessBuild successBuild;

  RefreshOController({
    required String url,
    required DXHttp http,
    required this.successBuild,
    RequestMethod method = RequestMethod.GET,
    Map<String, dynamic> params = const {},
    int emptyCode = 400,
    String? emptyStr,
    String? emptyUrl,
    bool isNeedCache = false,
    Widget? childHeader,
  }) : super(
            url: url,
            http: http,
            method: method,
            params: params,
            emptyCode: emptyCode,
            emptyStr: emptyStr,
            emptyUrl: emptyUrl,
            childHeader: childHeader,
            isList: false);
}

class RefreshOWidget extends StatelessWidget {
  final RefreshOController controller;

  RefreshOWidget(this.controller);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: controller.childHeader ??
          controller.getBaseHeader ??
          WaterDropHeader(),
      footer: null,
      controller: controller.refreshController,
      onRefresh: controller.refresh,
      child: CacheStreamBuild(
        getStream: controller.getStream,
        successBuild: controller.successBuild,
        emptyStr: controller.emptyStr,
        emptyUrl: controller.emptyUrl,
        controller: controller,
      ),
    );
  }
}
