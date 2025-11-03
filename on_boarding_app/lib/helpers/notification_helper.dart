import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../features/alarms/alarm_model.dart';

class NotificationHelper {
  static Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      
    );
  }

  static Future<void> scheduleAlarm(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    Alarm alarm,
  ) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'alarm_channel_id', 
      'Alarm Notifications',
      channelDescription: 'Channel for scheduled alarm notifications.',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('alarm_sound'),
      fullScreenIntent: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final tz.TZDateTime scheduledTime = 
        tz.TZDateTime.from(alarm.scheduledTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      alarm.id,
      'Smart Alarm Sync',
      'Time to sync! Your alarm is going off.',
      scheduledTime,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: 
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, 
    );
  }
  
  static Future<void> cancelAlarm(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    int id,
  ) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}