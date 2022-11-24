import 'package:common/common/startup/dispatcher.dart';

abstract class Startup extends Dispatcher {
  /// 创建任务
  bool create();

  /// 名称
  String get name;

  /// 依赖任务
  String? get dependency => null;
}
