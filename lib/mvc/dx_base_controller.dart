import 'package:flutter/material.dart';
import 'package:dx_plugin/dx_plugin.dart';

/// demo:
class _DemoModel extends BaseModel<_DemoController> {
  _DemoModel.fromController(_DemoController controller)
      : super.fromController(controller);
}

class _DemoController extends BaseController<_DemoModel> {
  @override
  _DemoModel initModel() => _DemoModel.fromController(this);
}

abstract class BaseController<M extends BaseModel> extends GetxController {
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
    model.onControllerClose();
    if (_awareBean != null) _unAwareSubscribe(_awareBean!.routeAware);
    super.onClose();
  }

  ///在controller onClose 关闭routeAware 订阅
  void _unAwareSubscribe(RouteAware routeAware) {
    routeObserver.unsubscribe(routeAware);
  }

  ///子controller构造器中订阅routeAware
  void _awareSubscribe(RouteAware routeAware, BuildContext context) {
    routeObserver.subscribe(routeAware, ModalRoute.of(context)!);
  }
}

abstract class BaseModel<C> {
  late C controller;

  ///初始化 controller
  BaseModel.fromController(C controller) {
    this.controller = controller;
  }

  ///初始化
  void init() {}

  ///controller 关闭回调--释放资源
  void onControllerClose() {}
}

class AwareBean {
  RouteAware routeAware;
  BuildContext context;

  AwareBean(this.routeAware, this.context);
}
