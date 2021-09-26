import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:navigation/archived_tasks.dart';
import 'package:navigation/done_tasks.dart';
import 'package:sqflite/sqflite.dart';
import 'new_tasks.dart';

class HomeLayout extends StatefulWidget {


  @override
  _HomeLayoutState createState() => _HomeLayoutState();

}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screen= [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
    List<String> titels=
        [
          'New Task',
          'Done Task',
          'Archived Task',
        ];
     Database database;
    @override
  void initState() {
    CreateDB();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TODO App'
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:     (){

          insertTODatabase();



  },
        child: Icon(
          Icons.add,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed ,
        currentIndex: currentIndex,
        onTap: (index ){

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
            label: 'tasks'
          ),
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
      body: screen[currentIndex],

    );
  }

 void CreateDB () async {

 database=     await  openDatabase(

       'todo1.db',
      version: 1,
      onCreate: ( database , version) async {
          print('database created');
         await database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY , title Text , date Text , time TEXT , status TEXT)')
             .
         catchError((error){
           print("error");

         });

      },

      onOpen: (database  ){
        print('database opened');

      },
     );
 }
  void insertTODatabase() {
    database.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO tasks(title,date,time,status) VALUES("first take","7/7/72002","10:10","sss")')
          .then((value) {
        print('$value insert successful');
      }).catchError((error) {
        print('Error when inserting new record ${error.toString()}');
      });
    });
  }
}
