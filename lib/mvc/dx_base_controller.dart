import 'package:dx_plugin/utils/dx_utils.dart';
import 'package:flutter/material.dart';
import 'package:dx_plugin/dx_plugin.dart';

abstract class BaseController<M extends BaseModel> extends GetxController
    with Dispose {
  late M model;
  AwareBean? _awareBean;

  set awareBean(AwareBean bean) {
    _awareBean = bean;
    _awareSubscribe(_awareBean!.routeAware, _awareBean!.context);
  }

  M initModel();

  BaseController() {
    model = initModel();
    model.init();
  }

  ///onDelete 会回调onClose
  @override
  void onClose() {
    model.mDispose();
    mDispose();
    if (_awareBean != null) _unAwareSubscribe(_awareBean!.routeAware);
    super.onClose();
  }

  @override
  void mDispose() {}

  ///在controller onClose 关闭routeAware 订阅
  void _unAwareSubscribe(RouteAware routeAware) {
    routeObserver.unsubscribe(routeAware);
  }

  ///子controller构造器中订阅routeAware
  void _awareSubscribe(RouteAware routeAware, BuildContext context) {
    routeObserver.subscribe(routeAware, ModalRoute.of(context)!);
  }
}

abstract class BaseModel<C> extends Dispose {
  late C controller;

  ///初始化 controller
  BaseModel.fromController(C controller) {
    this.controller = controller;
  }

  ///初始化
  void init() {}

  ///释放资源 -- controller onClose调用
  @override
  void mDispose() {}
}

class AwareBean {
  RouteAware routeAware;
  BuildContext context;

  AwareBean(this.routeAware, this.context);
}
