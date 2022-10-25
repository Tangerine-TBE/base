part of repo;

/// 与菜单管理相关的api仓库
class MenuRepo extends BaseRepo {
  /// 获取菜单状态Status
  Future<AResponse<MenuStatusBeanHolder>> fetchProfile() {
    return requestOnFuture(
      Api.menuStatus,
      method: Method.get,
      params: {
        'id': 'stub', // 显示传参 占个位
      },
      format: (data) => MenuStatusBeanHolder.fromMap(data),
    );
  }
}
