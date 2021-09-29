import 'package:flutter/material.dart';

Widget TaskItem(Map model) => Padding(
  padding: const EdgeInsets.all(10.0),
  child: Row(
    children: [
      CircleAvatar(
        radius: 40,
        child: Text(
            '${model['time']}'
        ),

      ),
      SizedBox(
        width: 20,
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${model['title']}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          Text(
            '${model['date']}',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    ],
  ),
);
