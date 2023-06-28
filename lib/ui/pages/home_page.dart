import 'dart:developer';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:todoapp/provider/home_page_provider.dart';

import '../../utils/db_opt/sqlhelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // bool _isLoading = true;

  int id = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final homeprovider =
          Provider.of<HomePageProvider>(context, listen: false);
      // homeprovider.addItem();
      homeprovider.refreshJournals();
    });
    super.initState();
    // initializeNotifications();
    // tz.initializeTimeZones();
    // // _refreshJournals();
    // Alarm.init();
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
        tz.TZDateTime.from(selectedDateTime, timeZone);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      tname,
      tdescription,
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // await flutterLocalNotificationsPlugin.show(
    //     1, tname, tdescription, platformChannelSpecifics);

    // final tzdatetime =
    //     tz.TZDateTime.from(scheduledNotificationDateTime, tz.local);
    print("$convertedDateTime");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      tname,
      tdescription,
      convertedDateTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      payload: 'alarm_payload',
    );

    print(convertedDateTime);

    // final alarmSettings = AlarmSettings(
    //   id: id,
    //   dateTime: selectedDateTime,
    //   assetAudioPath: 'Assets/music/BabyShark.mp3',
    //   loopAudio: true,
    //   vibrate: true,
    //   fadeDuration: 3.0,
    //   notificationTitle: tname,
    //   notificationBody: tdescription,
    //   enableNotificationOnKill: true,
    // );

    // Alarm.set(alarmSettings: alarmSettings);
    // print('Alaram Set');

    var diff = selectedDateTime.difference(DateTime.now());

    int hourSelected = diff.inHours.remainder(24);

    int minSelected = diff.inMinutes.remainder(60);

    int hourCurrent = DateTime.now().hour;
    int minCurrent = DateTime.now().minute;
    int totalHour = hourCurrent + hourSelected;
    int totalMin = minCurrent + minSelected + 1;

    print('$totalHour $totalMin');
    FlutterAlarmClock.createAlarm(totalHour, totalMin, title: tname);
    id += 1;
  }

  static ontask() {
    print('Task Running');
  }

  String timeUntilAlarm = '';
  void calculateTimeUntilAlarm() {
    if (selectedDateTime != null) {
      var difference = selectedDateTime.difference(DateTime.now());
      var timeLeft = '';
      if (difference.inDays > 0) {
        timeLeft += '${difference.inDays}d ';
      }
      if (difference.inHours > 0) {
        timeLeft += '${difference.inHours.remainder(24)}h ';
      }
      if (difference.inMinutes > 0) {
        timeLeft += '${difference.inMinutes.remainder(60)}m ';
      }
      if (difference.inSeconds > 0) {
        timeLeft += '${difference.inSeconds.remainder(60)}s ';
      }
      setState(() {
        timeUntilAlarm = timeLeft;
        // print('time until alaram $timeUntilAlarm');
        // print('time left  $timeLeft');
      });
    }
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _taskNameController.value.text,
        _taskDescController.value.text,
        _taskDateController.value.text,
        _taskTimeController.value.text);
    // _refreshJournals();
  }

  //update item
  // Future<void> __updateItem(int id) async {
  //   await SQLHelper.updateItem(
  //       id,
  //       _taskNameController.value.text,
  //       _taskDescController.value.text,
  //       _taskDateController.value.text,
  //       _taskTimeController.value.text);
  //   // _refreshJournals();
  // }

  //detete method
  void _deleteitem(int id, String taskname) async {
    await SQLHelper.deleteItem(id);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '$taskname Task Deleted!',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        ),
        backgroundColor: colorbg1));
    // AlertDialog(
    //   title: const Text(''),
    //   content: Text('Task "$taskname" Deleted Successfully! '),
    //   actions: <Widget>[
    //     TextButton(
    //       onPressed: () => Navigator.pop(context, 'Cancel'),
    //       child: const Text('Cancel'),
    //     ),
    //     TextButton(
    //       onPressed: () => Navigator.pop(context, 'OK'),
    //       child: const Text('OK'),
    //     ),
    //   ],
    // );

    // _refreshJournals();
  }

  // var parsedDate = DateTime.parse('1974-03-20 00:00:00.000');

  showAlertDialog(BuildContext context, int idtask, String taskName) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: const Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = ElevatedButton(
      child: const Text("Yes"),
      onPressed: () {
        _deleteitem(idtask, taskName);
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Alert!"),
      content: Text('Would you like to Delete Task "$taskName"'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  late String selectedDate;
  late String selectedTime;
  late DateTime selectedDateTime;
  late DateTime? pickedDate;
  late int hour;
  late int minutes;

  Color colorbg1 = const Color(0xFF298BFF);
  //Color(int.parse("#298BFF".substring(1, 7), radix: 16) + 0xFF000000);
  Color colorbg2 =
      Color(int.parse("#4189EA".substring(1, 7), radix: 16) + 0xFF000000);
  Color colorbg3 =
      Color(int.parse("#0478FF".substring(1, 7), radix: 16) + 0xFF000000);

  Color addButtonColor =
      Color(int.parse("#3787EB".substring(1, 7), radix: 16) + 0xFF000000);

  TextEditingController dateInput = TextEditingController();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();
  final TextEditingController _taskDateController = TextEditingController();
  final TextEditingController _taskTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomePageProvider>(
        builder: (context, taskModel, child) => Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        "Today's Task",
                        style: TextStyle(
                            fontFamily: "Inter",
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(31),
                              topLeft: Radius.circular(31)),
                          gradient: LinearGradient(
                              colors: [colorbg1, Colors.white],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Colors.black54,
                                blurRadius: 15.0,
                                offset: Offset(0.0, 0.75))
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: ListView.builder(
                            itemCount: taskModel.todolist.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(
                                    left: 5.0, right: 5.0),
                                child: Card(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: ListTile(
                                          // tileColor: Colors.amberAccent,
                                          leading: Container(
                                            height: 70.0,
                                            width: 60.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                              color: addButtonColor,
                                            ),
                                            child: Container(
                                              margin: const EdgeInsets.all(8.0),
                                              child: const ImageIcon(
                                                AssetImage(
                                                    'Assets/icons/list_icon.png'),
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            taskModel.todolist[index].title ??
                                                "",
                                            style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Text(
                                            taskModel.todolist[index]
                                                    .description ??
                                                "",
                                            style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        indent: 15,
                                        endIndent: 15,
                                        thickness: 0.9,
                                        color: Colors.grey,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, bottom: 16.0),
                                            child: Text(
                                              'Date: ${taskModel.todolist[index].date}',
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, bottom: 16.0),
                                            child: Text(
                                              'Time: ${taskModel.todolist[index].time}',
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 25.0, bottom: 16.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      blurRadius: 08,
                                                      blurStyle:
                                                          BlurStyle.outer,
                                                    )
                                                  ]),
                                              child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Colors.white,
                                                child: IconButton(
                                                  onPressed: () async =>
                                                      await taskModel
                                                          .goToCreateOrEditPage(
                                                              context,
                                                              task: taskModel
                                                                      .todolist[
                                                                  index]),
                                                  icon: const Icon(Icons.edit,
                                                      color: Colors.black),
                                                  iconSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0, bottom: 16.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: Colors.grey,
                                                        blurRadius: 08,
                                                        blurStyle:
                                                            BlurStyle.outer)
                                                  ]),
                                              child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Colors.white,
                                                child: IconButton(
                                                  onPressed: () {
                                                    // showAlertDialog(
                                                    //     context,
                                                    //     _todolist[index]['ID'],
                                                    //     _todolist[index]
                                                    //         ['TASKNAME']);
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.black,
                                                  ),
                                                  iconSize: 15,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ]),
            ),
            Positioned(
                bottom: 35,
                left: MediaQuery.of(context).size.width * 0.42,
                child: FloatingActionButton(
                  onPressed: () async =>
                      await taskModel.goToCreateOrEditPage(context),
                  backgroundColor: addButtonColor,
                  child: const Icon(
                    Icons.add,
                    size: 40,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
