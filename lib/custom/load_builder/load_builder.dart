import 'package:dx_plugin/dx_plugin.dart';
import 'package:dx_plugin/utils/dx_utils.dart';
import 'package:flutter/material.dart';

typedef SuccessBuild = Widget Function(Map<String, dynamic> map, bool isCache);
typedef StreamFun = Stream<ResponseBean> Function();
typedef FutureFun = Future<ResponseBean> Function();

enum NetworkStatus { SUCCESS, FAILED, EMPTY, LOADING }

class BuilderConfig {
  ///status:0--请求成功，1--list为空，2--请求失败
  final NetworkStatus Function(ResponseBean bean)? getNetworkStatus;

  ///加载widget
  final Widget Function()? loadBuilder;

  ///网络错误widget
  final Widget Function()? errorBuilder;

  ///空布局widget
  final Widget Function(String? url, String? str)? emptyBuilder;

  const BuilderConfig({
    this.getNetworkStatus,
    this.loadBuilder,
    this.errorBuilder,
    this.emptyBuilder,
  });
}

class LoadBuilder extends StatelessWidget {
  ///全局统一config
  static BuilderConfig? _baseConfig;

  static set baseConfig(BuilderConfig baseConfig) => _baseConfig = baseConfig;

  ///自定义config
  final BuilderConfig? childConfig;
  final streamFun? getStream;
  final futureFun? getFuture;
  final SuccessBuild successBuild;
  final String? emptyUrl;
  final String? emptyStr;
  final Function(NetworkStatus status)? statusCallback;
  final BuilderController? controller;
  final bool isList;
  final bool isFuture;

  const LoadBuilder._({
    required this.successBuild,
    required this.isFuture,
    this.getStream,
    this.getFuture,
    this.emptyUrl,
    this.emptyStr,
    this.statusCallback,
    this.isList = false,
    this.childConfig,
    this.controller,
  });

  ///FutureBuilder 构造器--工厂模式
  factory LoadBuilder.formFuture({
    required SuccessBuild successBuild,
    required futureFun getFuture,
    String? emptyUrl,
    String? emptyStr,
    Function(NetworkStatus status)? statusCallback,
    BuilderConfig? childConfig,
    BuilderController? controller,
  }) {
    return LoadBuilder._(
      successBuild: successBuild,
      getFuture: getFuture,
      emptyUrl: emptyUrl,
      emptyStr: emptyStr,
      statusCallback: statusCallback,
      childConfig: childConfig,
      controller: controller,
      isFuture: true,
    );
  }

  ///StreamBuilder 构造器--工厂模式
  factory LoadBuilder.formStream({
    required SuccessBuild successBuild,
    required streamFun getStream,
    String? emptyUrl,
    String? emptyStr,
    Function(NetworkStatus status)? statusCallback,
    bool isList = false,
    BuilderConfig? childConfig,
    BuilderController? controller,
  }) {
    return LoadBuilder._(
      successBuild: successBuild,
      getStream: getStream,
      emptyUrl: emptyUrl,
      emptyStr: emptyStr,
      statusCallback: statusCallback,
      isList: isList,
      childConfig: childConfig,
      controller: controller,
      isFuture: false,
    );
  }

  ///是否需要刷新
  bool _isNeedRefresh() => controller != null;

  ///获取当前配置
  BuilderConfig _getConfig() =>
      childConfig ?? _baseConfig ?? const BuilderConfig();

  @override
  Widget build(BuildContext context) {
    AsyncWidgetBuilder<ResponseBean> builder =
        (BuildContext context, AsyncSnapshot<ResponseBean> snapshot) {
      var config = _getConfig();
      if (snapshot.connectionState != ConnectionState.waiting) {
        if (snapshot.data != null) {
          //请求完成
          ResponseBean bean = snapshot.data!;
          //无配置getNetworkStatus默认请求成功,success、empty、failed
          var type = config.getNetworkStatus != null
              ? config.getNetworkStatus!(bean)
              : NetworkStatus.SUCCESS;
          statusCallback?.call(type);
          return getChild(type, bean: bean);
        }
        statusCallback?.call(NetworkStatus.FAILED);
        return getChild(NetworkStatus.FAILED);
      }
      return getChild(NetworkStatus.LOADING);
    };
    Widget getBuilderWidget({int? sum}) {
      Widget child = isFuture
          ? FutureBuilder(
        future: getFuture!(),
        builder: builder,
      )
          : StreamBuilder(
        stream: getStream!(),
        builder: builder,
      );
      return child;
    }

    return _isNeedRefresh()
        ? Obx(() {
      return getBuilderWidget(sum: controller!.cacheRefreshSum.value);
    }).setRefreshIndicator(() => controller!.cacheRefresh())
        : getBuilderWidget();
  }

  ///显示widget
  Widget getChild(NetworkStatus status, {ResponseBean? bean}) {
    var config = _getConfig();
    Widget child = Container();
    switch (status) {
      case NetworkStatus.SUCCESS:
        child = successBuild(bean!.map, bean.isCache);
        break;
      case NetworkStatus.EMPTY:
        child = config.emptyBuilder != null
            ? config.emptyBuilder!(emptyUrl, emptyStr)
            : Container(child: Text("默认空布局widget").setCenter());
        break;
      case NetworkStatus.FAILED:
        child = config.errorBuilder != null
            ? config.errorBuilder!()
            : Container(child: Text("默认错误widget,點擊重連").setCenter());
        if (_isNeedRefresh())
          child = child.setOnClickListener(() => controller!.cacheRefresh());
        break;
      case NetworkStatus.LOADING:
        child = config.loadBuilder != null
            ? config.loadBuilder!()
            : Container(child: Text("默认加载widget").setCenter());
        break;
    }
    return child;
  }
}

class BuilderController extends Dispose {
  var cacheRefreshSum = 0.obs;

  Future<void> cacheRefresh() async {
    cacheRefreshSum.value += 1;
  }

  @override
  void mDispose() {}
}
