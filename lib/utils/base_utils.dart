import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

abstract class DisposeController {
  void dispose();
}

///监听观察者
final RouteObserver<Route> routeObserver = RouteObserver();

///APP运行环境
enum EnvType { DEV, TEST, PRODUCTION, POS }

TextButton getTextButton({
  required Widget child,
  required Function onPressed,
  ButtonStyle? style,
  int interval = 500,
}) {
  var time = 0;
  var fun = () {
    if (DateTime.now().millisecondsSinceEpoch - time < interval) return;
    time = DateTime.now().millisecondsSinceEpoch;
    onPressed();
  };
  return TextButton(
    child: child,
    onPressed: fun,
    style: style,
  );
}

// ///快速创建button style
// ButtonStyle getButtonStyle(double fontSize,
//     {FontType? fontType,
//     Color? backgroundColor,
//     Color? textColor,
//     Color? borderColor,
//     double borderWidth = 0,
//     double? letterSpacing,
//     double? radius}) {
//   var colors = Get.context!.colors;
//   return ButtonStyle(
//     textStyle: MaterialStateProperty.all(getTextStyle(fontSize,
//         color: textColor,
//         fontType: fontType,
//         isButton: true,
//         letterSpacing: letterSpacing)),
//     backgroundColor: backgroundColor == null
//         ? null
//         : MaterialStateProperty.all(backgroundColor),
//     foregroundColor:
//         MaterialStateProperty.all(textColor ?? colors.defaultTextColor),
//     shape: radius == null
//         ? null
//         : MaterialStateProperty.all(RoundedRectangleBorder(
//             side: BorderSide(
//               color: borderColor ?? Colors.transparent,
//               width: borderWidth,
//             ),
//             borderRadius: BorderRadius.circular(radius))),
//   );
// }

// ///默認字體樣式
// TextStyle getTextStyle(double fontSize,
//     {Color? color,
//     double? height,
//     FontType? fontType,
//     TextDecoration? decoration,
//     double? letterSpacing,
//     TextDecorationStyle? decorationStyle,
//     bool isButton = false}) {
//   //button style 不能设置颜色
//   if (!isButton) color = color ?? Get.context!.colors.defaultTextColor;
//   return TextStyle(
//       fontSize: fontSize,
//       fontFamily: 'GenSen',
//       color: color,
//       decorationStyle: decorationStyle,
//       fontWeight:
//           FontUtils.getTypeStr(fontType ?? GeneralConstant.DEFAULT_FONT),
//       decoration: decoration ?? TextDecoration.none,
//       letterSpacing: letterSpacing,
//       height: height ?? 1);
// }

class BaseUtils {
  static T? getController<T extends GetxController>() {
    if (Get.isRegistered<T>())
      return Get.find<T>();
    else
      return null;
  }

  /// md5 加密
  static String md5Encoder(String data) {
    var content = Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  ///设置底部安全距离颜色  默认为背景设色
  static setAppStatusColor({Color? color}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
        statusBarColor: color ?? Colors.transparent));
  }

  // ///设置底部安全距离颜色  默认为背景设色
  // static setAppBottomColor({Color? color}) {
  //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //       systemNavigationBarColor:
  //           color ?? Get.context!.colors.scaffoldBackground));
  // }

  static showToast(String str) {
    SmartDialog.showToast(str);
    // Fluttertoast.showToast(
    //     msg: str,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  static offAndTo(String offName, String toName, {dynamic arguments}) {
    if (Get.currentRoute == offName) {
      Get.toNamed(toName, arguments: arguments);
      return;
    }
    Get.back();
    offAndTo(offName, toName, arguments: arguments);
  }

  static backTo(String offName) {
    if (Get.currentRoute != offName) {
      Get.back();
      backTo(offName);
    }
  }

  static copyText(String text, {String tips = '複製成功'}) {
    Clipboard.setData(ClipboardData(text: text));
    BaseUtils.showToast(tips);
  }

  //21-5  统一阴影边框
  static List<BoxShadow> getBoxShadow() {
    return [
      BoxShadow(
          color: Colors.black.setAlpha(0.1),
          // color: Colors.blue,
          offset: Offset(-1, 4), //阴影xy轴偏移量
          blurRadius: 10, //阴影模糊程度
          spreadRadius: 1 //阴影扩散程度
          )
    ];
  }
}

extension IntExt on int {
  int getLine(int lineSum) {
    return (this % lineSum == 0 ? this ~/ lineSum : (this ~/ lineSum) + 1);
  }
}

extension IntNullExt on int? {
  bool get isNullOrZero => this == null || this == 0;

  String get nullStr => this == null ? "0" : this.toString();

  String coinStr(int ratio) {
    num coin = this! / ratio;
    return coin.format;
  }
}

extension NumNullExt on num? {
  String get nullStr => this == null ? "0" : this.toString();

  String get format => this == null
      ? "0"
      : this! % 1 == 0
          ? this!.toInt().toString()
          : this!.toDouble().toString();

  String doubleSubFormat(num b) {
    return (((this! * 100).ceil() - (b * 100).ceil()) / 100).format;
  }
}

extension StringExt on String {
  bool get isExtEmpty => this == "";

  String get removeLast => this.isNullOrEmpty
      ? ''
      : this.replaceRange(this.length - 1, this.length, '');
}

extension StringNullExt on String? {
  String get nullStr => this ?? "";

  bool get isNullOrEmpty => this == null || this == "";
}

extension ListExt on List {
  bool get isExtEmpty => this.length == 0;
}

extension ListNullExt on List? {
  List get nullGet => this ?? [];
}

extension IterableNullExt on Iterable? {
  bool get isNullOrEmpty => this == null || this!.length == 0;
}

extension MapNullExt on Map? {
  bool get isNullOrEmpty => this == null || this!.length == 0;
}

extension WidgetExt on Widget {
  Widget setAutoFocus(List<FocusNode> focusList) {
    return this.setContainer(color: Colors.transparent).setOnClickListener(
        () => focusList.forEach((element) => element.unfocus()));
  }

  Widget setScroll() {
    return SingleChildScrollView(child: this);
  }

  Widget setVisibility(bool visible) {
    return Visibility(child: this, visible: visible);
  }

  Widget setRefreshIndicator(Future<void> Function() onRefresh) {
    return RefreshIndicator(child: this, onRefresh: onRefresh);
  }

  Widget setWillPopScope(WillPopCallback onWillPop) {
    return WillPopScope(child: this, onWillPop: onWillPop);
  }

  Widget setOnClickListener(GestureTapCallback onTap,
      {bool isInkWell = false, int interval = 500}) {
    var time = 0;
    var fun = () {
      if (DateTime.now().millisecondsSinceEpoch - time < interval) return;
      time = DateTime.now().millisecondsSinceEpoch;
      onTap();
    };
    return isInkWell
        ? InkWell(onTap: fun, child: this)
        : GestureDetector(child: this, onTap: fun);
  }

  Widget setCenter({bool isSet = true}) {
    return isSet ? Center(child: this) : this;
  }

  Widget setOnLongClickListener(GestureLongPressCallback onLongPress) {
    return GestureDetector(child: this, onLongPress: onLongPress);
  }

  Widget setOnFutureClickListener(Function onFutureClick) {
    return GestureDetector(child: this, onTap: () => onFutureClick());
  }

  Widget setOpacity(double alpha) {
    return Opacity(child: this, opacity: alpha);
  }

  Widget setContainer(
      {double? width,
      double? height,
      double? mainAxisSize,
      EdgeInsets? margin,
      AlignmentGeometry? alignment,
      Color? color,
      EdgeInsets? padding,
      BoxConstraints? constraints,
      Decoration? foregroundDecoration,
      Decoration? decoration,
      Key? key}) {
    return Container(
      alignment: alignment,
      constraints: constraints,
      key: key,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      padding: padding,
      color: color,
      margin: margin,
      width: width,
      height: height,
      child: this,
    );
  }
}

extension ColorExt on Color {
  Color setAlpha(double alpha) {
    return Color.fromARGB(
        (alpha * 255).toInt(), this.red, this.green, this.blue);
  }
}

extension MapExt<K, V> on Map<K, V> {
  V noNullGet<L>(K key) {
    if (this.containsKey(key)) return this[key] as V;
    if (judgeT<V, List>()) return <L>[] as V;
    if (V is String) return '' as V;
    if (V is int) return 0 as V;
    return '' as V;
  }
}

///判断泛型类型
bool judgeT<T, K>() {
  return <T>[] is List<K>;
}
