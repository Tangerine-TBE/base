import 'package:example/app/app_launcher.dart';
import 'package:example/app/launcher/strategy/production_launcher_strategy.dart';

void main() {
  AppLauncher.launch(ProductionLauncherStrategy());
}
