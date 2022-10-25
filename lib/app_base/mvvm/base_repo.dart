library repo;

import 'package:base/mvvm/repo/api_repository.dart';
import 'package:base/mvvm/repo/dio_proxy.dart';
import 'package:sample/app_base/repository/api.dart';
import '../http/sample_dio_proxy.dart';
import 'package:common/network/dio_client.dart';

// repos
part '../repository/menu_repo.dart';

// models
part '../model/menu_status.dart';

/// 业务层的base请求仓库
class BaseRepo extends ApiRepository {
  @override
  DioProxy proxy = SampleDioProxy.get();
}
