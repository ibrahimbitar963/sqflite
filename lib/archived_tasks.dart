import 'package:flutter/cupertino.dart';

class ArchivedTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'ARCHIVED TASKS',
        style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}
