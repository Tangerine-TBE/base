part of loading;
abstract class ILoading {
  void install(Widget loadingWidget);

  void showLoading();

  void dismiss();

  void showError(String? message);
}
