import 'package:flutter/material.dart';
import 'package:common/base/mvvm/view/base_view_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app_base/config/route_name.dart';
import 'home_page_controller.dart';

class HomePage extends BaseViewPage<HomePageController> {
  const HomePage({super.key, required super.controller});

  @override
  Widget buildContent(BuildContext context, HomePageController controller) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知测试'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
        child: Wrap(
          children: List.generate(
            controller.list.length,
            (index) => _buildWrapItem(controller.list[index].title, () {
              controller.onClick(controller.list[index].title);
            }),
          ),
          runSpacing: 20.w,
          spacing: 20.w,
        ),
      ),
    );
  }

  _buildWrapItem(String title, Function() onClick) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
      ),
      onPressed: onClick,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
