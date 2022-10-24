import 'package:sample/app/launcher/strategy/base_sample_launcher_strategy.dart';

/// Dev开发环境启动参数
class DevLauncherStrategy extends BaseSampleLauncherStrategy {
  @override
  String get envName => "dev";

  @override
  String get host => "https://api-dev.bw.com/";

  @override
  String proxy = "192.168.2.1";

  @override
  String proxyPort = "8888";
}
