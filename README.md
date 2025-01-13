# base

Flutter项目基础架构

## app
  1.base_material_app.dart 管理启动类（内含启动策略，启动配置等）

## mvvm.model
  1.data_holder.dart 数据转换持有层，主要负责转换json
  2.local_model.dart 数据示例
## mvvm.repo
  1.api_repository.dart 管理请求方法
  2.dio_proxy 管理dio网络请求 静态代理对象，可有多个proxy实现，用以在不同的环境下使用，一般只需要存在一个
## mvvm.view
  1.base_view_interface.dart 基础视图管理接口，用于指定view的加载事项
  2.base_view_page.dart 基础页面配置，统一管理所有路由页面,每一次都需要使用GoRouter中的extra传递一个Controller供页面使用
## mvvm.vm
  1.base_view_model.dart 管理所有的视图动作，管理所有的数据层操作 系视图与数据的交互介质

# example 
  1.dev 为示例入口 ，其启动策略与DevLauncherStrategy.dart有关
  2.app_launcher.dart 为策略后的启动项 ，主要为配置多语言，主题 和路由。
  3.rout_config.dart 其初始化在App_launcher 内含 initRouter loginRouter . 其中initRouter 为初始化路由 loginRouter为登录路由。
    一般需要在入口处判断当前Application的状态进而对login 或 init 的路由进行初始化
  ## http 基础的网络访问，可自由定义。

  

