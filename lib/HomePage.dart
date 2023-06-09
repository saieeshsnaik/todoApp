import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todoapp/sqlhelper.dart';
import 'addtask.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    print("number of items ${_TodoList.length}");
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _taskNameController.value.text,
        _taskDescController.value.text,
        _taskDateController.value.text,
        _taskTimeController.value.text);
    _refreshJournals();
    print("number of items ${_TodoList.length}");
    print(_TodoList);
  }

  //detete method
  void _deleteitem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        'Task Deleted!',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
      ),
      backgroundColor: Colors.white,
    ));

    _refreshJournals();
  }

  var value = "hello";

  Color color1 =
      Color(int.parse("#F69087".substring(1, 7), radix: 16) + 0xFF000000);
  Color color2 =
      Color(int.parse("#F45585".substring(1, 7), radix: 16) + 0xFF000000);

  TextEditingController dateInput = TextEditingController();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescController = TextEditingController();
  final TextEditingController _taskDateController = TextEditingController();
  final TextEditingController _taskTimeController = TextEditingController();

  void showForm() async {
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [color1, color2])),
        child: Card(
          margin: const EdgeInsets.all(40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white,
          elevation: 10,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(
                    left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
                child: Text(
                  "Add Task:",
                  // textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
                child: TextField(
                  controller: _taskNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Task Name',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
                child: TextField(
                  controller: _taskDescController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Task Description',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
                child: TextField(
                    controller: _taskDateController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      // icon: Icon(Icons.calendar_today), //icon of text field
                      hintText: 'Select Date',
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                      );
                      String formattedDate =
                          DateFormat('dd-MM-yyyy').format(pickedDate!);
                      setState(() {
                        _taskDateController.text = formattedDate;
                      });
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
                child: TextField(
                    controller: _taskTimeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      // icon: Icon(Icons.calendar_today), //icon of text field
                      hintText: 'Select Time',
                    ),
                    readOnly: true,
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      );
                      DateTime parsedTime = DateFormat.jm()
                          .parse(pickedTime!.format(context).toString());
                      String formattedTime =
                          DateFormat('HH:mm:ss').format(parsedTime);

                      setState(() {
                        _taskTimeController.text = formattedTime;
                      });
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        _taskNameController.text = '';
                        _taskTimeController.text = '';
                        _taskDescController.text = '';
                        _taskDateController.text = '';
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        _addItem();
                        Navigator.of(context).pop();
                        _taskNameController.text = '';
                        _taskTimeController.text = '';
                        _taskDescController.text = '';
                        _taskDateController.text = '';
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text("TodoList"),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                tileMode: TileMode.mirror,
                colors: [color1, color2])),
        child: ListView.builder(
          itemCount: _TodoList.length,
          itemBuilder: (context, index) {
            return Card(
              color: const Color.fromARGB(255, 255, 255, 255),
              shape: const RoundedRectangleBorder(
                  // side: BorderSide(width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(18))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    shape: const RoundedRectangleBorder(
                        // side: BorderSide(
                        //     width: 1,S
                        //     color: Color.fromARGB(132, 190, 169, 169)),
                        borderRadius: BorderRadius.all(Radius.circular(18))),
                    title: Text(
                      _TodoList[index]['TASKNAME'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "${_TodoList[index]['DESCRIPTION']}\n${_TodoList[index]['DATE']} \n${_TodoList[index]['TIME']}",
                      style: const TextStyle(color: Colors.black),
                    ),
                    isThreeLine: true,
                    onTap: () {
                      setState(() {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => ),
                        // );
                      });
                    },
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                          onPressed: () {
                            _deleteitem(_TodoList[index]['ID']);
                          },
                          icon: const Icon(Icons.delete)),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const AddTask()),
            // );
            showForm();
          });
        },
        label: const Text("Add Task"),
        icon: const Icon(Icons.add),
        backgroundColor: color2,
      ),
    );
  }
}
