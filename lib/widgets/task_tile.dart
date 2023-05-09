import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  bool isChecked = false;
  final String taskTitle;
  //final Function(bool?) checkboxCallback;
  final checkBox;
  final void Function() longPressCallback;

  TaskTile(
      {super.key,
      required this.taskTitle,
      required this.isChecked,
      //required this.checkboxCallback,
      required this.checkBox,
      required this.longPressCallback});

  @override
  Widget build(BuildContext context) {
    return taskTitle == ''
        ? Container()
        : ListTile(
            onLongPress: longPressCallback,
            title: Text(
              taskTitle,
              style: TextStyle(
                  fontSize: 18,
                  decoration: isChecked ? TextDecoration.lineThrough : null),
            ),
            trailing: Checkbox(
              activeColor: Colors.lightBlueAccent,
              value: isChecked,
              onChanged: checkBox,
              // onChanged: checkboxCallback,
            ));
  }
}
