part of loading;

class EasyLoadingImpl extends ILoading {
  @override
  void install(Widget loadingWidget) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorWidget = loadingWidget
      ..textColor = Colors.black54
      ..indicatorColor = Colors.red
      ..backgroundColor = Colors.transparent
      ..progressColor = Colors.yellow
      ..maskColor = Colors.transparent
      ..boxShadow = [];
  }

  @override
  void dismiss() {
    EasyLoading.dismiss();
  }

  @override
  void showLoading() {
    EasyLoading.show();
  }

  @override
  void showEmpty() {}

  @override
  void showError(String? message) {
    EasyLoading.showError(message ?? "");
  }
}
