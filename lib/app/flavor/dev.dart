import 'package:sample/app/app_launcher.dart';
import 'package:sample/app/launcher_strategy/dev_launcher_strategy.dart';

void main() {
  AppLauncher.launch(DevLauncherStrategy());
}