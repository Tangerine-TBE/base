import 'package:common/base/route/a_route.dart';
import '../../../app_base/config/route_name.dart';
import '../page1/home_page.dart';
import 'package:go_router/go_router.dart';

/// 服务项目的页面路由配置
class RouteConfig extends ARoute {
  @override
  String initialRoute = RouteName.home;

  @override
  String? loginRoute;

  @override
  GoRouter getPages() => GoRouter(
        routes: [
          GoRoute(
            path: RouteName.home,
            name: RouteName.home,
            builder: (context, state) => const HomePage(),
          ),
        ],
      );
}
