import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/create_task_provider.dart';
import 'package:todoapp/ui/pages/create_task.dart';
import 'package:todoapp/ui/pages/home_page.dart';

import '../../provider/home_page_provider.dart';

final routes = <String, WidgetBuilder>{
  '/': (_) => ChangeNotifierProvider<HomePageProvider>(
        create: (context) => HomePageProvider(),
        child: const HomePage(),
      ),
  '/CreateTask': (_) => ChangeNotifierProvider<CreateTaskProvider>(
        create: (context) => CreateTaskProvider(),
        child: const CreateTask(),
      )
};
