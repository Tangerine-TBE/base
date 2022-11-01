import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../helper/navigation_helper.dart';

/// 支持背景漸變、沉浸式基础page页面
abstract class BaseView<C> extends GetView<C> with NavigationHelper {
  const BaseView({Key? key}) : super(key: key);

  /// 构建appbar
  AppBar? buildAppBar();

  /// 构建drawer
  Widget? buildDrawer();

  /// 主视图区域
  Widget buildContent(BuildContext context);

  /// 主视图区域覆盖
  Widget buildContentCover(BuildContext context) => const Offstage();

  /// 纯色背景
  Color loadBackgroundColor() => const Color.fromARGB(255, 33, 33, 33);

  /// 系统导航栏颜色
  Color loadSystemNavigationBarColor() => const Color.fromARGB(255, 33, 37, 42);

  /// 渐变背景色
  List<Color>? loadGradientColors() => null;

  /// 返回按钮点击
  Future<bool>? onBackPressed() => null;

  @override
  Widget build(BuildContext context) {
    // bottom navigation
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: loadSystemNavigationBarColor(),
      ),
    );
    return WillPopScope(
      onWillPop: () => onBackPressed.call() ?? Future.value(true),
      child: Scaffold(
        // appbar
        appBar: buildAppBar(),
        // draw
        drawer: buildDrawer(),
        resizeToAvoidBottomInset: false,
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    List<Color> backgroundColor = [
      loadBackgroundColor(),
      loadBackgroundColor()
    ];
    List<Color>? gradientColors = loadGradientColors();

    var shaderColor = gradientColors ?? backgroundColor;

    return Stack(
      children: [
        // background
        ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: shaderColor,
            ).createShader(bounds);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0),
            ),
          ),
        ),
        buildContent(context),
        buildContentCover(context),
      ],
    );
  }
}
