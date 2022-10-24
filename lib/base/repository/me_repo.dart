part of repo;

/// 与我的相关的api仓库
class MeRepo extends BaseRepo {
  /// 获取我的账号信息
  Future<AResponse<dynamic>> fetchProfile(
    int id, {
    String? time,
  }) {
    return requestOnFuture(
      "api path",
      method: Method.get,
      params: {
        'id': id,
        'time': time,
      },
      format: (data) => "",
    );
  }
}
