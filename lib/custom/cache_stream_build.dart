import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dx_plugin/dx_plugin.dart';

typedef SuccessBuild = Widget Function(Map<String, dynamic> map, bool isCache);
typedef CacheSteam = Stream<ResponseBean> Function();

enum NetworkStatus { SUCCESS, FAILED, EMPTY, LOADING }

class CacheStreamConfig {
  ///status:0--请求成功，1--list为空，2--请求失败
  final NetworkStatus Function(ResponseBean bean)? getNetworkStatus;

  ///加载widget
  final Widget Function()? loadBuilder;

  ///网络错误widget
  final Widget Function()? errorBuilder;

  ///空布局widget
  final Widget Function(String? url, String? str)? emptyBuilder;

  const CacheStreamConfig({
    this.getNetworkStatus,
    this.loadBuilder,
    this.errorBuilder,
    this.emptyBuilder,
  });
}

///requestOnStream：isErrorReturn：必须为true,
// ignore: must_be_immutable
class CacheStreamBuild extends StatelessWidget {
  ///全局统一config
  static late final CacheStreamConfig? _baseConfig;

  static set baseConfig(CacheStreamConfig baseConfig) =>
      _baseConfig = baseConfig;

  ///自定义config
  final CacheStreamConfig? childConfig;
  final CacheSteam getStream;
  final SuccessBuild successBuild;
  final String? emptyUrl;
  final String? emptyStr;
  final Function(NetworkStatus status)? statusCallback;
  final CacheController? controller;
  final bool isList;

  const CacheStreamBuild({
    required this.getStream,
    required this.successBuild,
    this.emptyUrl,
    this.emptyStr,
    this.statusCallback,
    this.isList = false,
    this.childConfig,
    this.controller,
  });

  ///获取当前配置
  CacheStreamConfig _getConfig() =>
      childConfig ?? _baseConfig ?? const CacheStreamConfig();

  ///获取当前配置
  bool _getNeedRefresh() => controller != null;

  @override
  Widget build(BuildContext context) {
    return _getNeedRefresh()
        ? Obx(() {
            return getStreamBuilder(sum: controller!.cacheRefreshSum.value);
          })
        : getStreamBuilder();
  }

  Widget getStreamBuilder({int? sum}) {
    var config = _getConfig();
    return StreamBuilder(
      stream: getStream(),
      builder: (BuildContext context, AsyncSnapshot<ResponseBean> snapshot) {
        //请求完成
        if (snapshot.connectionState != ConnectionState.waiting) {
          if (snapshot.data != null) {
            ResponseBean bean = snapshot.data!;
            //无配置getNetworkStatus默认请求成功,success、empty、failed
            var type = config.getNetworkStatus != null
                ? config.getNetworkStatus!(bean)
                : NetworkStatus.SUCCESS;
            if (statusCallback != null) statusCallback!(type);
            return getChild(type, bean: bean);
          }
          if (statusCallback != null) statusCallback!(NetworkStatus.FAILED);
          return getChild(NetworkStatus.FAILED);
        }
        return getChild(NetworkStatus.LOADING);
      },
    );
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
        if (_getNeedRefresh())
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

class CacheController {
  var cacheRefreshSum = 0.obs;

  void cacheRefresh() {
    cacheRefreshSum.value += 1;
  }
}
