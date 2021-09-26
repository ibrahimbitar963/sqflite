import 'package:flutter/cupertino.dart';

class NewTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'NEW TASKS',
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
