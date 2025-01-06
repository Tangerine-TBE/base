import 'package:flutter/cupertino.dart';

import '../../app_launcher.dart';
import '../strategy/dev_launcher_strategy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppLauncher.launch(DevLauncherStrategy());
}
