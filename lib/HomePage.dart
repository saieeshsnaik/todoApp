import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todoapp/pag2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var value = "hello";
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
          itemCount: 10,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                  // side: BorderSide(width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(18))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    shape: const RoundedRectangleBorder(
                        // side: BorderSide(width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(18))),
                    title: const Text(
                      "Task Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      "Task Description \nTask Date \nTask Time",
                      style: TextStyle(color: Colors.black),
                    ),
                    isThreeLine: true,
                    onTap: () {
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Myapp2()),
                        );
                      });
                    },
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.delete)),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
