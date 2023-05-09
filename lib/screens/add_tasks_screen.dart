import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/models/task.dart';

import '../models/task_data.dart';

class AddTasksScreen extends StatelessWidget {
  const AddTasksScreen(
      {super.key, required this.addTaskCallBack, required this.user});
  final Function addTaskCallBack;
  final String? user;

  @override
  Widget build(BuildContext context) {
    String newTaskTitle = '';
    final _firestore = FirebaseFirestore.instance;

    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular((20.0)))),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text(
            'Add Task',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0, color: Colors.lightBlueAccent),
          ),
          TextField(
            autofocus: true,
            textAlign: TextAlign.center,
            onChanged: (newText) {
              newTaskTitle = newText;
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent),
            onPressed: () {
              // Provider.of<TaskData>(context, listen: false)
              //     .addTask(newTaskTitle);
              if (newTaskTitle != '') {
                _firestore.collection('todoList').add({
                  'user': user,
                  'task': newTaskTitle,
                  'isDone': false,
                  'timestamp': FieldValue.serverTimestamp(),
                });
              }

              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ]),
      ),
    );
  }
}
