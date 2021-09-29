import 'dart:ffi';

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:navigation/archived_tasks.dart';
import 'package:navigation/done_tasks.dart';
import 'package:sqflite/sqflite.dart';
import 'constans.dart';
import 'new_tasks.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screen = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titels = [
    'New Task',
    'Done Task',
    'Archived Task',
  ];
  Database database;
  bool isBouttomSheetShown = false;
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  IconData FABicon = Icons.edit;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  @override
  void initState() {
    CreateDB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: Text('TODO App'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBouttomSheetShown) {
            if (formkey.currentState.validate()) {
              insertTODatabase(
                time: timeController.text,
                title: titleController.text,
                date: dateController.text,
              ).then((value) {
                Navigator.pop(context);
                isBouttomSheetShown = false;
                setState(() {
                  FABicon = Icons.edit;
                });
              });
            }
          } else {
            scaffoldkey.currentState.showBottomSheet(
              (context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.grey[200],
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Title must not be empty';
                            }
                            return null;
                          },
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: 'Task Title',
                            prefixIcon: Icon(
                              Icons.title,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.datetime,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'time must not be empty';
                            }
                            return null;
                          },
                          onTap: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              timeController.text =
                                  value.format(context).toString();
                            });
                          },
                          controller: timeController,
                          decoration: InputDecoration(
                            labelText: 'Task Time',
                            prefixIcon: Icon(
                              Icons.watch_later_outlined,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.datetime,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Date must not be empty';
                            }
                            return null;
                          },
                          onTap: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2021-12-31'))
                                .then((value) {
                              dateController.text =
                                  DateFormat.yMMMd().format(value);
                            });
                          },
                          controller: dateController,
                          decoration: InputDecoration(
                            labelText: 'Task Date',
                            prefixIcon: Icon(
                              Icons.calendar_today_outlined,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ).closed.then((value) {
              isBouttomSheetShown = false;
              setState(() {
                FABicon = Icons.edit;
              });
            });
            isBouttomSheetShown = true;
            setState(() {
              FABicon = Icons.add;
            });
          }
        },
        child: Icon(FABicon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          print(index);
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.menu_outlined,
              ),
              label: 'tasks'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle_outline,
            ),
            label: 'DONE',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.archive_outlined,
            ),
            label: 'archived',
          ),
        ],
      ),
      body: ConditionalBuilder(
        builder:(context) =>screen[currentIndex] ,
        condition: tasks.length >0 ,
        fallback:(context) => CircularProgressIndicator(),
      ),
    );
  }

  void CreateDB() async {
    database = await openDatabase(
      'todo1.db',
      version: 1,
      onCreate: (database, version) async {
        print('database created');
        await database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY , title Text , date Text , time TEXT , status TEXT)')
            .catchError((error) {
          print("error");
        });
      },
      onOpen: (database) {
        print('database opened');
        getDataFromDatabase(database).
        then((value){
          tasks=value;
          print(tasks[0]);
        });
      },
    );
  }

  Future insertTODatabase({
    @required String title,
    @required String date,
    @required String time,
  }) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","sss")')
          .then((value) {
        print('$value insert successful');
      }).catchError((error) {
        print('Error when inserting new record ${error.toString()}');
      });
    });
  }
  Future<List<Map>> getDataFromDatabase(database) async{
     return await  database.rawQuery('SELECT * FROM tasks');
  }
}
