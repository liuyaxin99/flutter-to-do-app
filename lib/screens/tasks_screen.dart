import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/models/task_data.dart';
import 'package:todo_flutter/screens/add_tasks_screen.dart';
import 'package:todo_flutter/widgets/task_list.dart';
import 'package:todo_flutter/widgets/task_tile.dart';

class TasksScreen extends StatefulWidget {
  static const String id = 'tasks_screen';

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.lightBlueAccent,
          actions: [
            IconButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.logout))
          ]),
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => AddTasksScreen(
                  addTaskCallBack: (newTaskTitle) {
                    Navigator.pop(context);
                  },
                  user: loggedInUser.email));
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.only(
                  top: 60.0, left: 30.0, right: 30.0, bottom: 30),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30.0,
                      child: Icon(
                        Icons.list,
                        size: 30.0,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      children: const [
                        Text(
                          'To Do',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 50.0,
                              fontWeight: FontWeight.w700),
                        ),
                        // Text('${Provider.of<TaskData>(context).taskCount} Tasks',
                        //     style:
                        //         const TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                  ])),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _firestore
                          .collection('todoList')
                          .orderBy('timestamp')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.lightBlueAccent),
                          );
                        } else {
                          final tasks = snapshot.data?.docs;
                          List<TaskTile> taskWidgets = [];
                          for (var task in tasks!) {
                            final taskText = task.data()['task'];
                            final taskUser = task.data()['user'];
                            bool taskStatus = task.data()['isDone'];
                            final taskId = task.id;
                            final currentUser = loggedInUser.email;
                            final TaskTile taskWidget;
                            if (currentUser == taskUser) {
                              taskWidget = TaskTile(
                                  taskTitle: taskText,
                                  isChecked: taskStatus,
                                  checkBox: (bool? value) {
                                    if (taskStatus == false) {
                                      FirebaseFirestore.instance
                                          .collection('todoList')
                                          .doc(taskId)
                                          .update({
                                        'isDone': true,
                                      });
                                    } else {
                                      FirebaseFirestore.instance
                                          .collection('todoList')
                                          .doc(taskId)
                                          .update({
                                        'isDone': false,
                                      });
                                    }
                                    setState(() {
                                      taskStatus = value!;
                                    });
                                  },
                                  longPressCallback: () {
                                    FirebaseFirestore.instance
                                        .collection('todoList')
                                        .doc(taskId)
                                        .delete();
                                  });
                            } else {
                              taskWidget = TaskTile(
                                  taskTitle: '',
                                  checkBox: null,
                                  isChecked: taskStatus,
                                  longPressCallback: () {});
                            }
                            taskWidgets.add(taskWidget);
                          }
                          return ListView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 20.0),
                            children: taskWidgets,
                          );
                        }
                      })))
        ],
      ),
    );
  }
}
