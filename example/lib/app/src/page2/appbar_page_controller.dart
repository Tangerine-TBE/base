import 'package:common/common/log/a_logger.dart';
import 'package:example/app_base/mvvm/base_controller.dart';
import 'package:example/app_base/mvvm/base_repo.dart';
import 'package:get/get.dart';

class AppBarPageController extends BaseController {
  final MenuRepo _menuRepo = Get.find();

  // @override
  // onInit() {
  //   super.onInit();
  // }

  Future<void> fetchMenuStatus() async {
    logW(".....");
    MenuStatusBeanHolder? holder =
    await apiLaunch(() => _menuRepo.fetchProfile());
    logW("response: ${holder?.dataList}");
  }
}