import 'package:flutter/material.dart';
import 'package:todoapp/models/data_models/task.dart';
import 'package:todoapp/utils/db_opt/sqlhelper.dart';

class HomePageProvider extends ChangeNotifier {
  Color colorbg1 = const Color(0xFF298BFF);
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

  void _deleteitem(int id, String taskname, BuildContext context) async {
    await SQLHelper.deleteItem(id);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '$taskname Task Deleted!',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
        ),
        backgroundColor: colorbg1));
    refreshJournals();
  }

  showAlertDialog(BuildContext context, int? idtask, String? taskName) {
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
        _deleteitem(idtask!, taskName!, context);
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
}
