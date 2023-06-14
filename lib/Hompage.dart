import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:indexed/indexed.dart';
import 'package:todoapp/HomePage.dart';

import 'createtask.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Color colorbg1 =
      Color(int.parse("#298BFF".substring(1, 7), radix: 16) + 0xFF000000);
  Color colorbg2 =
      Color(int.parse("#4189EA".substring(1, 7), radix: 16) + 0xFF000000);
  Color colorbg3 =
      Color(int.parse("#0478FF".substring(1, 7), radix: 16) + 0xFF000000);

  Color addButtonColor =
      Color(int.parse("#3787EB".substring(1, 7), radix: 16) + 0xFF000000);

  void showForm() async {
    // Container(
    //   height: double.infinity,
    //   color: Colors.amber,
    //   child: const Card(
    //     color: Colors.white,
    //     child: Text("hello"),
    //   ),
    // );
  }

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
                  child: ListView.builder(
                    itemCount: 1,
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
                                      borderRadius: BorderRadius.circular(6.0),
                                      color: addButtonColor,
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.all(8.0),
                                      child: const ImageIcon(
                                        AssetImage(
                                            'Assets/icons/list_icon.png'),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  title: const Text(
                                    'Task Name',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: const Text(
                                    'Lorem epsumn Lorem epsumn Lorem epsumn Lorem epsumn Lorem epsumn',
                                    style: TextStyle(
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
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.0, bottom: 16.0),
                                    child: Text(
                                      "Date: 2023-06-12",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 8.0, bottom: 16.0),
                                    child: Text(
                                      "Time: 9:00am",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 72.0, bottom: 16.0),
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
                                          onPressed: () {},
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
                                          onPressed: () {},
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
              const SizedBox(
                height: 60,
              ),
            ]),
          ),
          Positioned(
              bottom: 35,
              left: 167,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateTask(),
                        ));
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
