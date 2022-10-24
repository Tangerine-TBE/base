# base

Flutter项目基础架构

## Getting Started

### 1. 目录说明

- lib（架构代码运用实例）
  - app
    - flavor // 启动对应的环境
    - launcher_strategy // 环境配置策略
    - src // 页面、业务
  - base
    - http // 网络请求对象、拦截器
    - repository // api仓库
- library（核心架构代码）
  - base (package)
    - helper
    - mvvm // MVVM架构基类
      - model // 数据模型
      - repo // api仓库、api数据转换
      - view // 基于GetView<C>，base_page、base_appbar_page封装基础页面
      - vm // 基于GetXController的数据持久化层、持有repo对象
    - build_config.dart // 静态环境变量
  - common (package)
    - common // 可共享组件和拓展
    - launcher // 启动策略
    - log // 日志工具
    - network // 网络请求工具

### 2. /lib/base 详细说明

#### 2.1 http 请求

- 主要看sample_dio_proxy，继承DioProxy按照模板配置参数，自身做一个单例
- 另外所有拦截器也放这里

#### 2.2 repository 请求仓库

- base_repo.dart 作为基础请求仓库的存在，提供并持有dio代理对象
- 其他仓库，如me_repo.dart，都需要继承base_repo.dart

### 3. /lib/app 详细说明

- flavor 启动入口，配合Android Studio的Run Configuration使用
- launcher_strategy 启动策略，专注配置环境变量
- src 页面和业务，可参考如何实现MVVM