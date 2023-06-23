import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:indexed/indexed.dart';
import 'package:todoapp/sqlhelper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';

import 'createtask.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Map<String, dynamic>> _TodoList = [];
  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _TodoList = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshJournals();
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _taskNameController.value.text,
        _taskDescController.value.text,
        _taskDateController.value.text,
        _taskTimeController.value.text);
    _refreshJournals();
  }

  //update item
  Future<void> __updateItem(int id) async {
    await SQLHelper.updateItem(
        id,
        _taskNameController.value.text,
        _taskDescController.value.text,
        _taskDateController.value.text,
        _taskTimeController.value.text);
    _refreshJournals();
  }

  //detete method
  void _deleteitem(int id, String taskname) async {
    await SQLHelper.deleteItem(id);
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

    _refreshJournals();
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

  void showmodel([int? id]) async {
    if (id != null) {
      final existingJournal =
          _TodoList.firstWhere((element) => element['ID'] == id);
      _taskNameController.text = existingJournal['TASKNAME'];
      _taskDescController.text = existingJournal['DESCRIPTION'];
      _taskDateController.text = existingJournal['DATE'];
      _taskTimeController.text = existingJournal['TIME'];
    }
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 90,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                    ),
                    child: BackButton(
                      color: Colors.grey.shade400,
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Homepage(),
                              ));
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Text(
                    id != null ? 'Update Existing Task' : 'Create New Task',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  'Task Name',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _taskNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey.shade100)),
                    hintText: '',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  'Select Date',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _taskDateController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        iconSize: 30,
                        color: Colors.blue.shade300,
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate!);

                          // String formattedDateTwo =
                          //     DateFormat('yyyy-MM-dd').format(DateTime.now());
                          setState(() {
                            _taskDateController.text = formattedDate;
                          });
                          // Icon Calender Acction
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey.shade100)),
                      hintText: 'YYYY-MM-DD',
                      hintStyle: const TextStyle(
                          fontFamily: 'Inter', fontWeight: FontWeight.w500)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  'Select Time',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _taskTimeController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey.shade100)),
                      hintText: 'HH:MM:SS',
                      hintStyle: const TextStyle(
                          fontFamily: 'Inter', fontWeight: FontWeight.w500)),
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );

                    //Extracting Am Or Pm From time
                    String period = pickedTime!.period.toString();
                    String pr = period.substring(10, 12);

                    DateTime parsedTime = DateFormat.jm()
                        .parse(pickedTime.format(context).toString());
                    String formattedTime =
                        ' ${DateFormat('HH:mm').format(parsedTime)} $pr';

                    //  DateTime parsedTimeTwo = DateFormat.jm()
                    //     .parse(pickedTime!.format(context).toString());
                    // String formattedTime =
                    //     DateFormat('HH:mm:ss').format(parsedTime);

                    setState(() {
                      _taskTimeController.text = formattedTime;
                      // print(
                      //     int.parse(_taskTimeController.text.substring(0, 3)));
                      // print(
                      //     int.parse(_taskTimeController.text.substring(4, 6)));
                    });
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  'Description',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _taskDescController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey.shade100)),
                    hintText: 'Description',
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (id == null) {
                          _addItem();

                          // Create an alarm at 23:59
                          FlutterAlarmClock.createAlarm(
                              int.parse(
                                  _taskTimeController.text.substring(0, 3)),
                              int.parse(
                                  _taskTimeController.text.substring(4, 6)),
                              title: _taskNameController.text);

                          Navigator.of(context).pop();
                          _taskNameController.text = '';
                          _taskTimeController.text = '';
                          _taskDescController.text = '';
                          _taskDateController.text = '';
                        } else {
                          __updateItem(id);
                          Navigator.of(context).pop();
                          _taskNameController.text = '';
                          _taskTimeController.text = '';
                          _taskDescController.text = '';
                          _taskDateController.text = '';
                        }
                      });
                    },
                    child: Text(
                      id != null ? 'Update Task' : 'Create New Task',
                      style: const TextStyle(
                          fontSize: 20,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  Color colorbg1 =
      Color(int.parse("#298BFF".substring(1, 7), radix: 16) + 0xFF000000);
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
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(color: Colors.white),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      itemCount: _TodoList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Card(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
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
                                      _TodoList[index]['TASKNAME'],
                                      style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      _TodoList[index]['DESCRIPTION'],
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
                                        'Date: ${_TodoList[index]['DATE']}',
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
                                        'Time: ${_TodoList[index]['TIME']}',
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
                                                blurStyle: BlurStyle.outer,
                                              )
                                            ]),
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Colors.white,
                                          child: IconButton(
                                            onPressed: () {
                                              showmodel(_TodoList[index]['ID']);
                                            },
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
                                                  blurStyle: BlurStyle.outer)
                                            ]),
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Colors.white,
                                          child: IconButton(
                                            onPressed: () {
                                              showAlertDialog(
                                                  context,
                                                  _TodoList[index]['ID'],
                                                  _TodoList[index]['TASKNAME']);
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
                onPressed: () {
                  setState(() {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => const CreateTask(),
                    //     ));
                    showmodel();
                  });
                },
                backgroundColor: addButtonColor,
                child: const Icon(
                  Icons.add,
                  size: 40,
                ),
              ))
        ],
      ),
    );
  }
}
