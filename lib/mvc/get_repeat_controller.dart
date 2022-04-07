import 'package:get/get.dart';

///tag 自动递增 controller
abstract class GetRepeatController {
  int controllerNum = 0;

  //重复出现的Controller在值后面+出现次数
  static T getController<T extends GetRepeatController>(T repeatController) {
    var oldController = Get.put(repeatController);
    var newController = oldController.controllerNum == 0
        ? oldController
        : Get.put(repeatController, tag: "${oldController.controllerNum}");
    oldController.controllerNum++;
    return newController;
  }
}
