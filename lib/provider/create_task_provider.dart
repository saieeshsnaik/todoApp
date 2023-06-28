import 'package:flutter/material.dart';
import 'package:todoapp/models/data_models/task.dart';
import 'package:todoapp/utils/db_opt/sqlhelper.dart';

class CreateTaskProvider extends ChangeNotifier {
  Task? recievedTask;
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
}
