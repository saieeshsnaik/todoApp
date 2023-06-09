import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:todoapp/sqlhelper.dart';
import 'HomePage.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController dateInput = TextEditingController();

  Color color1 =
      Color(int.parse("#F69087".substring(1, 7), radix: 16) + 0xFF000000);
  Color color2 =
      Color(int.parse("#F45585".substring(1, 7), radix: 16) + 0xFF000000);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        // title: const Text("Add Task"),
      ),
      body: Container(
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
                  textDirection: TextDirection.ltr,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.only(
                    left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Task Name',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(
                    left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
                child: TextField(
                  decoration: InputDecoration(
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
                    controller: dateInput,
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
                    }),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, top: 0.0, right: 10.0, bottom: 0.0),
                child: TextField(
                    controller: dateInput,
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
                      onPressed: () {},
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
                      onPressed: () {},
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
}
