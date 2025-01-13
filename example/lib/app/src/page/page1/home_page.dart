import 'package:flutter/material.dart';
import 'package:common/base/mvvm/view/base_view_page.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app_base/config/route_name.dart';
import 'home_page_controller.dart';

class HomePage extends BaseViewPage<HomePageController> {
  const HomePage({super.key,required super.controller});

  @override
  Widget buildContent(BuildContext context ,HomePageController controller) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.pushNamed(RouteName.page2,);
              },
              child: const Text("navi to page2"),
            ),
          ],
        ),
      ),
    );
  }
}
