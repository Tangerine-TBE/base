part of common;

extension ContextExt on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
}
