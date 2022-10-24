import 'package:sample/app/app_launcher.dart';
import 'package:sample/launcher/production_launcher_strategy.dart';

void main() {
  AppLauncher.launch(ProductionLauncherStrategy());
}