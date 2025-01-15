import 'dart:math';

import 'package:example/app/src/page/bean/wrap_item_info.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../app_base/mvvm/base_controller.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePageController extends BaseController {
  List<WrapItemInfo> list = [];
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    _initializeNotifications();
    list.add(
      WrapItemInfo(title: '测试通知'),
    );
    list.add(
      WrapItemInfo(title: '测试Toast'),
    );
    super.onInit();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('TestNotification', 'TestNotification',
        channelDescription: '这只是一次测试通知',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: false);

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
        Random().nextInt(100), '通知标题', '这是通知内容', platformChannelSpecifics);
  }

  void onClick(String title) {
    if (title == '测试通知') {
      _showNotification();
    } else if (title == '测试Toast') {
      EasyLoading.showToast('这是一次Toast');
    }
  }
}
