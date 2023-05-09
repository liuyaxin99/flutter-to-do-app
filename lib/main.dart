import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_flutter/models/task_data.dart';
import 'package:todo_flutter/screens/login_screen.dart';
import 'package:todo_flutter/screens/registration_screen.dart';
import 'package:todo_flutter/screens/tasks_screen.dart';
import 'package:todo_flutter/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        TasksScreen.id: (context) => TasksScreen(),
      },
    );
    // return ChangeNotifierProvider(
    //   create: (BuildContext context) => TaskData(),
    //   child: MaterialApp(
    //     initialRoute: WelcomeScreen.id,
    //     routes: {
    //       WelcomeScreen.id: (context) => WelcomeScreen(),
    //       LoginScreen.id: (context) => LoginScreen(),
    //       RegistrationScreen.id: (context) => RegistrationScreen(),
    //       TasksScreen.id: (context) => TasksScreen(),
    //     },
    //   ),
    // );
  }
}
