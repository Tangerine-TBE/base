import 'package:common/base/route/a_route.dart';
import '../../../app_base/config/route_name.dart';
import '../page1/home_page.dart';
import 'package:go_router/go_router.dart';
import 'package:common/base/mvvm/vm/base_view_model.dart';

import '../page1/home_page_controller.dart';

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
              return  HomePage(controller: HomePageController(),);
            },
          ),
        ],
      );
}

buildTargetController(BaseViewModel t){
  if(t is HomePageController){
    return HomePageController();
  }
}
