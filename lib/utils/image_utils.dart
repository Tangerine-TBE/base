import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dx_plugin/utils/dx_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ImageType { ASSET, FILE, SVG, NETWORK }

///ImageUtils网络图片 loading图、底图、packageName
class ImageConfig {
  String defaultUrl; //加载底图
  String loadingUrl; //loading图片
  String package;

  ImageConfig({
    this.defaultUrl = '',
    this.loadingUrl = '',
    this.package = '',
  });
}

///圖片工具類
///app中初始化 ImageUtils.config
class ImageUtils {
  static late ImageConfig? _config;

  static set config(ImageConfig config) {
    _config = config;
  }

  ///svg圖片 默認加載本地資源
  static Widget image(String url,
      {Color? color,
      String? packageName,
      ImageType imageType = ImageType.ASSET,
      double radius = 0,
      double? height,
      double? width,
      double alpha = 1,
      BoxFit? fit}) {
    var config = _config ?? ImageConfig();
    Widget widget;
    switch (imageType) {
      case ImageType.FILE:
        widget = Image.file(
          File(url),
          fit: _getBoxFit(height, width, fit),
          height: height,
          width: width,
        );
        break;
      case ImageType.NETWORK:
        widget = CachedNetworkImage(
            imageUrl: url,
            width: width,
            height: height,
            fit: _getBoxFit(height, width, fit),
            placeholder: (context, url) => ImageUtils.image(config.loadingUrl,
                packageName: config.package, height: height, width: width),
            errorWidget: (context, url, error) {
              return ImageUtils.image(
                config.defaultUrl,
                packageName: config.package,
                height: height,
                width: width,
              );
            });
        break;
      case ImageType.SVG:
        widget = SvgPicture.asset(url,
            package: packageName,
            fit: _getBoxFit(height, width, fit),
            height: height,
            width: width,
            color: color);
        break;
      default:
        widget = Image.asset(url,
            package: packageName,
            fit: _getBoxFit(height, width, fit),
            height: height,
            width: width,
            color: color);
        break;
    }
    if (radius != 0)
      widget = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: widget,
      );
    if (alpha < 1) widget = widget.setOpacity(alpha);
    return widget;
  }

  static BoxFit _getBoxFit(double? height, double? width, BoxFit? fit) {
    if (fit != null) {
      return fit;
    }
    if (width != null && height != null) {
      return BoxFit.cover;
    }
    if (width != null) {
      return BoxFit.fitWidth;
    }
    if (height != null) {
      return BoxFit.fitHeight;
    }
    return BoxFit.cover;
  }
}
