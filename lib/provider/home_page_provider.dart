import 'package:flutter/material.dart';
import 'package:todoapp/models/data_models/task.dart';
import 'package:todoapp/utils/db_opt/sqlhelper.dart';

class HomePageProvider extends ChangeNotifier {
  List<Task> todolist = [];
  set setTodoList(List<Task> val) {
    todolist = val;
    notifyListeners();
  }

  Future<void> refreshJournals() async {
    final data = await SQLHelper.getItems();
    setTodoList = Task().fromJsonList(data);
  }

  Future<void> goToCreateOrEditPage(BuildContext context, {Task? task}) async {
    await Navigator.pushNamed(context, '/CreateTask', arguments: task)
        .then((value) async => await refreshJournals());
  }
}
