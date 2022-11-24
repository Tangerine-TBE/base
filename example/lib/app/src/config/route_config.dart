import 'package:common/base/route/a_route.dart';
import 'package:example/app_base/config/route_name.dart';
import 'package:get/get.dart';

import '../page1/home_page.dart';
import '../page1/home_page_controller.dart';
import '../page2/appbar_page.dart';
import '../page2/appbar_page_controller.dart';
import '../../../app_base/mvvm/base_repo.dart';

/// 服务项目的页面路由配置
class RouteConfig extends ARoute {

  @override
  List<GetPage> getPages() => [
        GetPage<dynamic>(
          name: RouteName.home,
          page: () => const HomePage(),
          binding: BindingsBuilder<HomePageController>(() {
            Get.lazyPut(() => HomePageController());
          }),
        ),
        GetPage(
          name: RouteName.appBarPage,
          page: () => const AppBarPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut(() => AppBarPageController());
            Get.lazyPut(() => MenuRepo());
          }),
        ),
      ];

  @override
  String initialRoute = RouteName.home;

  @override
  String? loginRoute;
}
