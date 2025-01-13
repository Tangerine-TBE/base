import 'package:example/app/src/page1/home_page_controller.dart';
import 'package:flutter/material.dart';
import '../../../app_base/config/route_name.dart';
import 'package:common/base/mvvm/view/base_view_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends BaseViewPage<HomePageController> {
  const HomePage({super.key,required super.controller});

  @override
  Widget buildContent(BuildContext context ,HomePageController controller) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              context.pushNamed(RouteName.appBarPage);
            },
            child: const Text("Appbar Page Sample, color blue"),
          ),
          SizedBox(height: 12.w),
          ElevatedButton(
            onPressed: () {
              context.pushNamed(RouteName.appBarPage2);
            },
            child: const Text("Appbar Page Sample, color amber"),
          ),
          SizedBox(height: 12.w),
          ElevatedButton(
            onPressed: () {
              context.pushNamed(RouteName.download);
            },
            child: const Text("Download Page Sample"),
          ),
        ],
      ),
    );
  }
}
