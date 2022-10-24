part of repo;

/// 与我的相关的api仓库
class MeRepo extends BaseRepo {
  /// 获取我的账号信息
  Future<AResponse<dynamic>> fetchProfile(
    int storeId,
    int? categoryId,
    int? statusId, {
    // 搜索关键字
    String? keyword,
  }) {
    return requestOnFuture("path");
  }
}
