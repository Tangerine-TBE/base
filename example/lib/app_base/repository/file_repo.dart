import 'package:example/app_base/app_base.dart';

class FileRepo extends BaseRepo {
  Future downFile(
    String url, {
    required String savePath,
  }) {
    return download(url, savePath: savePath);
  }
}
