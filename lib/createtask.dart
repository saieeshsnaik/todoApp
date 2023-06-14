import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    onPressed: () {},
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 60),
                child: Text(
                  'Create New Task',
                  style: TextStyle(
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
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      iconSize: 30,
                      color: Colors.blue.shade300,
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () {
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
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey.shade100)),
                    hintText: 'HH:MM:SS',
                    hintStyle: const TextStyle(
                        fontFamily: 'Inter', fontWeight: FontWeight.w500)),
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
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey.shade100)),
                  hintText:
                      'lorem epsum lorem epsum lorem epsum lorem epsum lorem epsum lorem epsum lorem epsum ',
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
                  onPressed: () {},
                  child: const Text('Create Task'),
                ),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
