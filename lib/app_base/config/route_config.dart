library route;

import 'package:base/route/a_route.dart';
import 'package:get/get.dart';
import 'package:sample/app/src/page1/home_page.dart';
import 'package:sample/app/src/page1/home_page_controller.dart';
import 'package:sample/app/src/page2/appbar_page.dart';
import 'package:sample/app/src/page2/appbar_page_controller.dart';

part 'route_name.dart';

/// 服务项目的页面路由配置
class RouteConfig extends ARoute {

  @override
  List<GetPage> getPages() => [
        GetPage(
          name: RouteName.home,
          page: () => const HomePage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => HomePageController());
          }),
        ),
        GetPage(
          name: RouteName.appBarPage,
          page: () => const AppBarPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => AppBarPageController());
          }),
        ),
      ];

  @override
  String initialRoute = RouteName.home;
}
