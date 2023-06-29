import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/models/data_models/task.dart';
import 'package:todoapp/utils/db_opt/sqlhelper.dart';
import 'package:timezone/timezone.dart' as tz;

class CreateTaskProvider extends ChangeNotifier {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Task? recievedTask;
  DateTime? selectedDateTime;
  set setRecievedTask(Task? val) {
    recievedTask = val;
    notifyListeners();
  }

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescController = TextEditingController();
  final TextEditingController taskDateController = TextEditingController();
  final TextEditingController taskTimeController = TextEditingController();

  Future<void> addItem(BuildContext context) async {
    await SQLHelper.createItem(
      taskNameController.value.text,
      taskDescController.value.text,
      taskDateController.value.text,
      taskTimeController.value.text,
    );
    await scheduleAlarm(
        taskNameController.value.text, taskDescController.value.text);

    if (context.mounted) Navigator.pop(context);
  }

  Future<void> updateItem(BuildContext context) async {
    await SQLHelper.updateItem(
        recievedTask!.id!,
        taskNameController.value.text,
        taskDescController.value.text,
        taskDateController.value.text,
        taskTimeController.value.text);

    if (context.mounted) Navigator.pop(context);
  }

  Future<void> assignValue(BuildContext context) async {
    setRecievedTask = ModalRoute.of(context)!.settings.arguments as Task?;
    if (recievedTask != null) {
      taskNameController.text = recievedTask!.title ?? "";
      taskDescController.text = recievedTask!.description ?? "";
      taskDateController.text = recievedTask!.date ?? "";
      taskTimeController.text = recievedTask!.time ?? "";
    }
  }

  Future<void> onButtonClick(BuildContext context) async {
    if (recievedTask != null) {
      await updateItem(context);
    } else {
      await addItem(context);
    }
  }

  DateTime? pickedDate;
  Future<void> datePicker(BuildContext context) async {
    pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate!);
    taskDateController.text = formattedDate;
  }

  Future<void> timePicker(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (kDebugMode) {
      print(pickedTime);
    }
    if (pickedTime != null) {}
    selectedDateTime = DateTime(
      pickedDate!.year,
      pickedDate!.month,
      pickedDate!.day,
      pickedTime!.hour,
      pickedTime.minute,
    );
    taskTimeController.text = pickedTime!.format(context);
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    bool? initialized = await flutterLocalNotificationsPlugin
        .initialize(initializationSettings);
    log("Iitialized:$initialized");
  }

  Future<void> scheduleAlarm(String tname, String tdescription) async {
    var scheduledNotificationDateTime = selectedDateTime;
    tz.Location timeZone = tz.getLocation('Asia/Kolkata');
    tz.TZDateTime convertedDateTime =
        tz.TZDateTime.from(selectedDateTime!, timeZone);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      tname,
      tdescription,
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    if (kDebugMode) {
      print("$convertedDateTime");
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      tname,
      tdescription,
      convertedDateTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      payload: 'alarm_payload',
    );

    if (kDebugMode) {
      print(convertedDateTime);
    }
    alaram(tname, tdescription);
  }

  Future<void> alaram(String tname, String tdescription) async {
    final alarmSettings = AlarmSettings(
      id: 0,
      dateTime: selectedDateTime!,
      assetAudioPath: 'assets/audio/baby_shark.mp3',
      loopAudio: true,
      vibrate: true,
      fadeDuration: 0.0,
      notificationTitle: tname,
      notificationBody: tdescription,
      enableNotificationOnKill: true,
      stopOnNotificationOpen: true,
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }
}
