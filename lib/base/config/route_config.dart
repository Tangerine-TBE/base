library route;

import 'package:base/route/a_route.dart';
import 'package:get/get.dart';
import 'package:sample/app/src/page1/home_page.dart';
import 'package:sample/app/src/page1/home_page_controller.dart';

part 'route_name.dart';

/// 服务项目的页面路由配置
class RouteConfig extends ARoute {
  // static RouteConfig? _instance;
  //
  // factory RouteConfig.get() => _getInstance();
  //
  // static _getInstance() {
  //   _instance ??= RouteConfig._init();
  // }
  // RouteConfig._init();

  /// TODO
  @override
  List<GetPage> getPages() => [
        GetPage(
          name: RouteName.home,
          page: () => const HomePage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => HomePageController());
          }),
        ),
      ];
}
