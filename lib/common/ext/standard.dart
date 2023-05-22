import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:get_storage/get_storage.dart';

extension NullStringExt on String? {
  String get val => isNullOrEmpty ? '' : this!;

  bool isNum(String value) => GetUtils.isNum(value);
}

extension StringExt on String {
  // this 作為key，去storage中讀寫值
  save(dynamic value) => GetStorage().write(this, value);

  get read => GetStorage().read(this);
}

extension NullNumExt on num? {
  num get val => isNullOrEmpty ? 0 : this!;
}

extension IntExt on int? {
  int get val => isNullOrEmpty ? 0 : this!;
}

extension DoubleExt on double? {
  double get val => isNullOrEmpty ? 0 : this!;
}

extension BoolExt on bool? {
  bool get val => this == null ? false : this == true;
}

extension Dynamic on dynamic {
  bool get isEmpty => GetUtils.isBlank(this) == true;

  bool get isNullOrEmpty => GetUtils.isNullOrBlank(this) == true;
}
