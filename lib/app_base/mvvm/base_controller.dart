import 'package:base/mvvm/vm/base_view_model.dart';
import 'package:common/common/top.dart';

class BaseController extends BaseViewModel {
  @override
  void handleUnAuthorizedError() {
    showToast("401 or 403");
  }

  @override
  void showEmpty() {}

  @override
  void showError(String? message) {
    showToast(message);
  }
}
