import 'package:dx_plugin/custom/load_builder/load_builder.dart';
import 'package:dx_plugin/example/http_example.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LoadBuilderExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  Widget _getStreamBuilder() {
    return LoadBuilder.formStream(
      successBuild: (Map<String, dynamic> map, bool isCache) {
        return Container();
      },
      getStream: () => DemoHttp.instance().requestOnStream(path: 'path'),
    );
  }

  Widget _getFutureBuilder() {
    return LoadBuilder.formFuture(
      successBuild: (Map<String, dynamic> map, bool isCache) {
        return Container();
      },
      getFuture: () => DemoHttp.instance().requestOnFuture(path: 'path'),
      // getStream: () => DemoHttp.instance().requestOnStream(path: 'path'),
    );
  }
}
