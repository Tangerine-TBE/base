import 'package:sample/app/app_launcher.dart';
import 'package:sample/app/launcher/strategy/production_launcher_strategy.dart';

void main() {
  AppLauncher.launch(ProductionLauncherStrategy());
}