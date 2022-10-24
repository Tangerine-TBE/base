extension StringExt on String? {
  bool get isNullOrEmpty => this == null || this == "";

  String get value => isNullOrEmpty ? "" : this!;
}

extension BoolExt on bool? {
  bool get value => this == null ? false : this == true;
}
