import 'package:common/base/route/a_route.dart';
import 'package:example/app/src/page/page2/view_2_controller.dart';
import 'package:example/app/src/page/page2/view_2_page.dart';
import '../../../app_base/config/route_name.dart';
import '../page/page1/home_page.dart';
import '../page/page1/home_page_controller.dart';
import 'package:go_router/go_router.dart';
import 'package:common/base/mvvm/vm/base_view_model.dart';

/// 服务项目的页面路由配置
class RouteConfig extends ARoute {
  @override
  String initialRoute = RouteName.home;

  @override
  String? loginRoute;

  @override
  GoRouter getPages() => GoRouter(
        initialLocation: initialRoute,
        routes: [
          GoRoute(
            path: RouteName.home,
            builder: (context, state) {
              return HomePage(
                controller: HomePageController(),
              );
            },
          ),
          GoRoute(
            path: RouteName.page2,
            name: RouteName.page2,
            builder: (context, state) {
              return View2Page(
                controller: View2Controller(),
              );
            },
          ),
        ],
      );
}
