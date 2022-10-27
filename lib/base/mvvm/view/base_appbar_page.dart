import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'base_view.dart';

/// 基础带appbar的page
abstract class BaseAppBarPage<C> extends BaseView<C> {
  const BaseAppBarPage({Key? key}) : super(key: key);

  /// 子类填写标题
  abstract final String appBarTitle;

  /// 加载appbar背景色
  Color loadAppbarBackgroundColor() => const Color.fromARGB(255, 33, 33, 33);

  /// 左边按钮图标
  Widget? buildLeftIcon() => const Icon(Icons.arrow_back_outlined);

  /// 右边按钮图标
  Widget? buildRightIcon() => const Icon(Icons.menu_rounded);

  /// 左边按钮点击
  onTapLeft() => finish();

  /// 右边按钮点击
  onTapRight(BuildContext context) => {};

  @override
  Widget? buildDrawer() => null;

  @override
  AppBar? buildAppBar() => _customAppBar();

  /// 自定义AppBar (leading & actions)
  AppBar _customAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        appBarTitle,
        style: TextStyle(fontSize: 18.w, fontWeight: FontWeight.w700),
      ),
      leading: InkWell(
        onTap: () => onTapLeft.call(),
        child: Container(
          padding: EdgeInsets.only(left: 12.w),
          alignment: Alignment.centerLeft,
          child: buildLeftIcon(),
        ),
      ),
      leadingWidth: 100,
      backgroundColor: loadAppbarBackgroundColor(),
      actions: [
        Builder(
          builder: (context) => InkWell(
            onTap: () => onTapRight.call(context),
            child: Container(
              padding: EdgeInsets.only(right: 12.w, left: 12.w),
              alignment: Alignment.centerRight,
              child: buildRightIcon(),
            ),
          ),
        ),
      ],
    );
  }

}
