import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:navigation/components/components.dart';

import 'constans.dart';

class NewTasksScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context , index) =>TaskItem(tasks[index]),
        separatorBuilder: (context , index)=>Container(
          width: double.infinity,
          color: Colors.black26,
          height: 1,
        ),
        itemCount: tasks.length);

  }
}
