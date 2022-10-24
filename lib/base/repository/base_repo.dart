library repo;

import 'package:base/mvvm/repo/api_repository.dart';
import 'package:base/mvvm/repo/dio_proxy.dart';
import '../http/a_request_invoker.dart';
import 'package:common/network/dio_client.dart';

// repos
part 'me_repo.dart';

/// 业务层的base请求仓库
class BaseRepo extends ApiRepository {
  @override
  DioProxy proxy = SampleDioProxy.get();
}
