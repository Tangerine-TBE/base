import 'package:common/base/mvvm/view/base_view.dart';
import 'package:flutter/material.dart';

abstract class BaseEmptyPage extends BaseView {
  const BaseEmptyPage({Key? key}) : super(key: key);

  @override
  AppBar? buildAppBar() => null;

  @override
  Widget? buildBottomNavigation() => null;


  @override
  Widget? buildDrawer() => null;

  @override
  Widget? buildFloatingActionButton() => null;

  @override
  FloatingActionButtonLocation? get floatingActionButtonLocation => null;

}