import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';

class SocketConfig {
  String link;
  String pingStr;
  String pongStr;
  String successStr;
  late List<String> ignoreList;
  Duration? pingInterval;
  int reconnectInterval; //单位秒
  bool isAutoReconnect;

  SocketConfig(
      {required this.link,
      this.pingStr = 'PING',
      this.pongStr = 'PONG',
      this.successStr = 'conn_success',
      List<String> ignoreList = const [],
      this.reconnectInterval = 1,
      this.isAutoReconnect = true,
      this.pingInterval}) {
    this.ignoreList = []
      ..addAll(ignoreList)
      ..addAll([successStr, pongStr]);
  }
}

abstract class BaseSocketManager {
  late IOWebSocketChannel _socketChannel;
  String _logTag = 'webSocket------------';
  Timer? pingTimer;
  Timer? reConnectTimer;
  late SocketConfig config;
  bool isDispose = false;

  ///设置连接link
  SocketConfig initConfig();

  ///处理socket消息
  void handleMsg(String msg);

  ///连接失败回调
  void onError(dynamic error) {}

  ///关闭回调
  void onDone() {}

  ///重连回调
  void onReConnect() {}

  ///连接成功回调
  void onConnectSuccess() {}

  void init() {
    config = initConfig();
    _socketChannel = IOWebSocketChannel.connect(Uri.parse(config.link));
    _socketChannel.stream.listen((message) {
      debugPrint("$_logTag,message=$message");
      //连接成功
      if (message == config.successStr) {
        onConnectSuccess();
        _startSendPing();
      }
      //忽略消息
      if (config.ignoreList.contains(message)) return;
      handleMsg(message);
    }, onError: (error) {
      _stopSendPing();
      onError(error);
      if (config.isAutoReconnect) _reConnect();
    }, onDone: () {
      _stopSendPing();
      onDone();
      if (config.isAutoReconnect) _reConnect();
    });
  }

  ///开始发送心跳
  void _startSendPing() {
    if (config.pingInterval == null) return;
    pingTimer = Timer(config.pingInterval!, () {
      debugPrint("$_logTag,send=${config.pingStr}");
      _socketChannel.sink.add(config.pingStr);
      _startSendPing();
    });
  }

  ///停止发送心跳
  void _stopSendPing() {
    debugPrint("$_logTag,_stopSendPing");
    if (config.pingInterval == null || pingTimer == null) return;
    pingTimer!.cancel();
    pingTimer = null;
  }

  ///重连
  void _reConnect() {
    if (reConnectTimer != null || isDispose) return;
    reConnectTimer = Timer(Duration(seconds: config.reconnectInterval), () {
      reConnectTimer = null;
      debugPrint("$_logTag,reConnect");
      onReConnect();
      init();
    });
  }

  void _disposeReconnect() {
    debugPrint(
        "$_logTag,_disposeReconnect,reConnectTimer=${reConnectTimer == null}");
    if (reConnectTimer != null) {
      reConnectTimer!.cancel();
      reConnectTimer = null;
    }
  }

  void dispose() {
    isDispose = true;
    _socketChannel.sink.close();
    _disposeReconnect();
    _stopSendPing();
  }
}
