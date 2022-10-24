import 'package:common/launcher/a_launcher_strategy.dart';

abstract class BaseSampleLauncherStrategy extends BaseLauncherStrategy {
  /// 代理服务器
  abstract String proxy;

  /// 代理服务器端口
  abstract String proxyPort;
}
