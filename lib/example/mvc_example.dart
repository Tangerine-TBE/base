import 'package:dx_plugin/dx_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class DemoModel extends BaseModel<DemoController> {
  DemoModel.fromController(DemoController controller)
      : super.fromController(controller);

  @override
  void init() {}
}

class DemoController extends BaseController<DemoModel> {
  @override
  DemoModel initModel() => DemoModel.fromController(this);
}

// ignore: must_be_immutable
class DemoPage extends StatelessWidget with BasePage<BaseController> {
  @override

  ///初始化Controller
  void initBasePage(BuildContext context) {
    initBase(DemoController(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
