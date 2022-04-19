import 'package:dx_plugin/custom/refresh/refresh_base_controller.dart';
import 'package:dx_plugin/network/dx_http.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:get/get.dart';
import 'package:dx_plugin/dx_plugin.dart';

///加载底部widget,config
class FooterConfig {
  final TextStyle? textStyle;
  final Widget Function()? idleBuilder; //上拉加載
  final Widget Function()? loadingBuilder; //load more...
  final Widget Function()? failedBuilder; //加載失敗
  final Widget Function()? canLoadingBuilder; //鬆手,加載更多
  final Widget Function()? noDataBuilder; //沒有數據啦!

  const FooterConfig({
    this.textStyle,
    this.idleBuilder,
    this.loadingBuilder,
    this.failedBuilder,
    this.canLoadingBuilder,
    this.noDataBuilder,
  });
}

/// 加载时：SmartRefresher->cacheStreamBuilder
/// 加载完：SmartRefresher->ListView
///功能：、空布局、网络布局(点击重连)、下拉刷新、上拉加载、分页
class RefreshLController<T> extends BaseRefreshController {
  final int initPage; //初始页数
  final String pageStr; //request参数key
  final int pageSize; //单页数据量
  final bool isNeedLoad; //是否需要上拉加载
  final bool isNeedRefresh; //是否需要下拉刷新
  ///item清除回调
  final Function(bool isDispose)? onItemClean;

  ///map转beanList
  List<T> Function(Map<String, dynamic> map, List<T> dataList) mapToList;

  ///item 实例方法
  Widget Function(int index, T bean) itemWidgetBuilder;

  FooterConfig? footerConfig;

  RefreshLController({
    required String url,
    required DXHttp http,
    required this.mapToList,
    required this.itemWidgetBuilder,
    RequestMethod method = RequestMethod.GET,
    Map<String, dynamic> params = const {},
    String? emptyStr,
    String? emptyUrl,
    int emptyCode = 400,
    Widget? childHeader,
    this.initPage = 1,
    this.pageStr = 'page',
    this.pageSize = 20,
    this.isNeedLoad = true,
    this.isNeedRefresh = true,
    this.onItemClean,
    this.footerConfig,
  }) : super(
            url: url,
            http: http,
            method: method,
            params: params,
            emptyCode: emptyCode,
            emptyStr: emptyStr,
            emptyUrl: emptyUrl,
            childHeader: childHeader,
            isList: true) {
    _init();
  }

  late int _currentPage;
  Map<int, Widget> _widgetMap = {}; //保存itemWidget 避免reBuild
  List<T> _beanList = [];
  var itemLength = 0.obs;
  var isSuccess = false.obs; //首页是否请求完成，判断显示list or csb；

  ///初始化 刷新、dispose调用
  void _init() {
    _currentPage = initPage;
    itemLength.value = 0;
    params[pageStr] = _currentPage;
    onItemClean?.call(false);
    _widgetMap.clear();
    _beanList = [];
    setIsSuccess(false);
  }

  ///下拉刷新
  @override
  void refresh() {
    _init();
    super.refresh();
  }

  ///加载更多
  void loadMore() {
    //未请求成功不加载
    if (!isSuccess.value) {
      refreshController.loadComplete();
      return;
    }
    callbackRequest();
  }

  ///加载callback请求
  void callbackRequest() async {
    //list 递增 page
    _currentPage++;
    params[pageStr] = _currentPage;
    http.requestOnCallBack(
      path: url,
      onSuccess: (map) => parseMap(map),
      onError: (msg, code) => onCallRequestError(code),
      isErrorToast: false,
      isShowLoading: false,
      method: RequestMethod.GET,
      params: params,
    );
  }

  ///加载请求错误回调
  void onCallRequestError(int code) {
    if (code == emptyCode) {
      //请求为空
      refreshController.loadNoData();
    } else {
      //网络错误
      _currentPage--;
      refreshController.loadFailed();
    }
  }

  ///解析json数据，stream、refresh、loadMore都会走此方法,
  void parseMap(Map<String, dynamic> map, {bool isStream = false}) {
    _beanList = mapToList(map, _beanList);
    //不是第一页更新load状态
    if (_currentPage > initPage) {
      //加载
      if (_beanList.length < _currentPage * pageSize) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }
    var fun = () => itemLength.value = _beanList.length;
    if (isStream)
      Future.delayed(Duration(milliseconds: 16), fun);
    else
      fun();
  }

  ///item实例方法
  Widget itemBuilder(BuildContext context, int index) {
    var bean = _beanList[index];
    if (!_widgetMap.containsKey(index)) {
      _widgetMap[index] =
          itemWidgetBuilder(index, bean).setVisibility(bean != null);
    }
    return _widgetMap[index]!;
  }

  @override
  void mDispose() {
    onItemClean?.call(true);
    super.mDispose();
  }

  void setIsSuccess(bool success) {
    if (isSuccess.value == success) return;
    isSuccess.value = success;
  }
}

class RefreshLWidget<T> extends StatelessWidget {
  final RefreshLController<T> controller;

  RefreshLWidget(this.controller);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var isSuccess = controller.isSuccess.value;
      //成功build
      var successBuild = (map, isCache) {
        controller.parseMap(map, isStream: true);
        return Container();
      };
      //状态改变
      var statusCallback = (NetworkStatus status) {
        Future.delayed(Duration(milliseconds: 16), () {
          var isSuccess = status == NetworkStatus.SUCCESS;
          controller.setIsSuccess(isSuccess);
        });
      };
      Widget child;
      if (isSuccess) {
        child = ListView.builder(
            itemBuilder: controller.itemBuilder,
            itemCount: controller.itemLength.value);
      } else {
        child = CacheStreamBuild(
          getStream: controller.getStream,
          successBuild: successBuild,
          statusCallback: statusCallback,
          controller: controller,
          emptyStr: controller.emptyStr,
          emptyUrl: controller.emptyUrl,
        );
      }
      return SmartRefresher(
        enablePullDown: controller.isNeedRefresh,
        enablePullUp: controller.isNeedRefresh,
        header: controller.isNeedRefresh ? WaterDropHeader() : null,
        footer: customFooter(),
        controller: controller.refreshController,
        onRefresh: controller.refresh,
        onLoading: controller.loadMore,
        child: child,
      );
    });
  }

  ///下拉刷新widget
  Widget? getHeaderWidget() {
    return controller.isNeedRefresh
        ? controller.getBaseHeader ?? WaterDropHeader()
        : null;
  }

  ///上拉加载widget
  Widget? customFooter() {
    var config = controller.footerConfig ??
        controller.getBaseFoot ??
        const FooterConfig();
    var textStyle = config.textStyle;
    return controller.isNeedLoad
        ? CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              Widget Function() body;
              switch (mode) {
                case LoadStatus.idle:
                  body = config.idleBuilder ??
                      () => Text("上拉加載", style: textStyle);
                  break;
                case LoadStatus.loading:
                  body = config.loadingBuilder ??
                      () => Text("load more...", style: textStyle);
                  break;
                case LoadStatus.failed:
                  body = config.failedBuilder ??
                      () => Text("加載失敗！點擊重試！", style: textStyle);
                  break;
                case LoadStatus.canLoading:
                  body = config.canLoadingBuilder ??
                      () => Text("鬆手,加載更多!", style: textStyle);
                  break;
                default:
                  body = config.noDataBuilder ??
                      () => Text("沒有數據啦!", style: textStyle);
                  break;
              }
              return Container(
                child: Center(child: body()),
              );
            },
          )
        : null;
  }
}
