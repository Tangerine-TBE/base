abstract class Dispatcher {
  /// 优先级
  int get priority;

  /// 是否在主线程执行
  bool get callCreateOnMainThread;
}
