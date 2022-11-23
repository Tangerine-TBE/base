part of common_top;

extension StringExt on String? {
  String get value => isNullOrEmpty ? '' : this!;

  bool isNum(String value) => GetUtils.isNum(value);
}

extension NumExt on num? {
  num get value => isNullOrEmpty ? 0 : this!;
}

extension BoolExt on bool? {
  bool get value => this == null ? false : this == true;
}

extension Dynamic on dynamic {
  bool get isEmpty => GetUtils.isBlank(this) == true;

  bool get isNullOrEmpty => GetUtils.isNullOrBlank(this) == true;
}
