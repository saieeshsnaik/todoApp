import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/create_task_provider.dart';
import 'package:todoapp/ui/pages/home_page.dart';
import 'package:todoapp/utils/validation/validation.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final createprovider =
          Provider.of<CreateTaskProvider>(context, listen: false);

      createprovider.assignValue(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CreateTaskProvider>(
        builder: (context, createModel, child) => SingleChildScrollView(
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
                        Navigator.pop(context);
                      },
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
                child: StreamBuilder(
                    stream: createModel.name,
                    builder: (context, snapshot) {
                      return TextField(
                        controller: createModel.taskNameController,
                        onChanged: createModel.changeName,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade100)),
                            hintText: 'Task Name',
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null),
                      );
                    }),
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
                child: StreamBuilder<Object>(
                    stream: createModel.date,
                    builder: (context, snapshot) {
                      return TextField(
                        controller: createModel.taskDateController,
                        onChanged: createModel.changeDate,
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
                                borderSide:
                                    BorderSide(color: Colors.grey.shade100)),
                            hintText: 'YYYY-MM-DD',
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            hintStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500)),
                        onTap: () async =>
                            await createModel.datePicker(context),
                      );
                    }),
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
                child: StreamBuilder<Object>(
                    stream: createModel.time,
                    builder: (context, snapshot) {
                      return TextField(
                        controller: createModel.taskTimeController,
                        onChanged: createModel.changeTime,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade100)),
                            hintText: 'HH:MM:SS',
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null,
                            hintStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500)),
                        onTap: () async =>
                            await createModel.timePicker(context),
                      );
                    }),
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
                child: StreamBuilder<Object>(
                    stream: createModel.desc,
                    builder: (context, snapshot) {
                      return TextField(
                        controller: createModel.taskDescController,
                        onChanged: createModel.changeDesc,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade100)),
                          hintText: 'Description',
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : null,
                        ),
                      );
                    }),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: StreamBuilder<bool>(
                      stream: createModel.submitValid,
                      builder: (context, snapshot) {
                        return ElevatedButton(
                          onPressed: !snapshot.hasData
                              ? null
                              : () async => createModel.onButtonClick(context),
                          child: Text(createModel.recievedTask != null
                              ? 'Update Task'
                              : 'Create Task'),
                        );
                      }),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
