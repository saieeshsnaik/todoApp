import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todoapp/models/data_models/task.dart';
import 'package:todoapp/utils/db_opt/sqlhelper.dart';
import '../utils/validation/validation.dart';
import 'package:todoapp/services/notification_services.dart';

class CreateTaskProvider extends ChangeNotifier with CreateTaskValidator {
  Task? recievedTask;

  late DateTime selectedDateTime;
  set setRecievedTask(Task? val) {
    recievedTask = val;
    notifyListeners();
  }

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescController = TextEditingController();
  final TextEditingController taskDateController = TextEditingController();
  final TextEditingController taskTimeController = TextEditingController();

  //streams get and set
  final _name = BehaviorSubject<String>();
  final _date = BehaviorSubject<String>();
  final _time = BehaviorSubject<String>();
  final _desc = BehaviorSubject<String>();

  Stream<String> get name => _name.stream.transform(validateName);
  Stream<String> get date => _date.stream.transform(validateDate);
  Stream<String> get time => _time.stream.transform(validateTime);
  Stream<String> get desc => _desc.stream.transform(validateDesc);

  Stream<bool> get submitValid =>
      Rx.combineLatest4(name, date, time, desc, (e, m, t, d) => true);

  // Sink<String> get sinkName => _name.sink;
  // Sink<String> get sinkDate => _date.sink;
  // Sink<String> get sinkTime => _time.sink;
  // Sink<String> get sinkDesc => _desc.sink;

  Function(String) get changeName => _name.sink.add;
  Function(String) get changeDate => _date.sink.add;
  Function(String) get changeTime => _time.sink.add;
  Function(String) get changeDesc => _desc.sink.add;

  Future<void> addItem(BuildContext context) async {
    await SQLHelper.createItem(
      taskNameController.value.text,
      taskDescController.value.text,
      taskDateController.value.text,
      taskTimeController.value.text,
    );

    int? recievedId = await SQLHelper.getId();

    await notify(recievedId, taskNameController.value.text,
        taskDescController.value.text);

    // await alaram(recievedId!, taskNameController.value.text,
    //     taskDescController.value.text);

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
    changeDate(formattedDate);
  }

  Future<void> timePicker(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (kDebugMode) {
      print(pickedTime);
    }
    if (pickedTime != null && context.mounted) {
      selectedDateTime = DateTime(
        pickedDate!.year,
        pickedDate!.month,
        pickedDate!.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      taskTimeController.text = pickedTime.format(context);
      changeTime(pickedTime.format(context));
      // (selectedDateTime);print
    }
  }

  Future<void> notify(int? id, String tname, String tdesc) async {
    NotificationService().scheduleNotification(
        id: id!,
        title: tname,
        body: tdesc,
        scheduledNotificationDateTime: selectedDateTime);
  }

// // Method to trigger alaram when task added
//   Future<void> alaram(int id, String tname, String tdesc) async {
//     final alarmSettings = AlarmSettings(
//       id: id,
//       dateTime: selectedDateTime,
//       assetAudioPath: 'assets/audio/Reminder.mp3',
//       loopAudio: false,
//       vibrate: true,
//       volumeMax: true,
//       fadeDuration: 3.0,
//       notificationTitle: tname,
//       notificationBody: tdesc,
//       enableNotificationOnKill: true,
//       stopOnNotificationOpen: true,
//     );
//     await Alarm.set(alarmSettings: alarmSettings);
//   }
}
