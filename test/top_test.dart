import 'package:common/common/top.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("get value via .value ext", () {
    num zero = 0;
    expect(0, zero.value);
    num? nullNum;
    expect(0, nullNum.value);

    bool? bol;
    expect(false, bol.value);
    bool? t = true;
    expect(true, t.value);
  });
}
