import 'dart:math';

import 'package:common/common/log/a_logger.dart';
import 'package:common/common/startup/startup.dart';

/// 存储排好序的startup各种表
class StartupStore {
  StartupStore(
    this.priorityMap,
    this.dependencyMap,
    this.freeStartups,
  );

  /// 执行优先级
  Map<String, int> priorityMap = {};

  /// startup依赖关系表
  Map<String, List<String>> dependencyMap = {};

  /// 可自由初始化的startup
  List<Startup> freeStartups = [];

  /// find the first startup name
  String first() {
    int maxNum = -1;
    priorityMap.forEach((key, value) {
      maxNum = max(maxNum, value);
    });
    return priorityMap.entries
        .firstWhere((element) => element.value == maxNum)
        .key;
  }

  void print() {
    logI("priorityMap: ${priorityMap}\n"
        "dependencyMap: ${dependencyMap}\n"
        "freeStartups: ${freeStartups}");
  }
}
