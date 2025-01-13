import 'package:common/base/mvvm/view/base_view_page.dart';
import 'package:example/app/src/page/page2/view_2_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class View2Page extends BaseViewPage<View2Controller> {
  const View2Page({super.key, required super.controller});

  @override
  Widget buildContent(BuildContext context, View2Controller controller) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(),),
      body: const Center(
        child: Text('this is view2'),
      ),
    );
  }
}
