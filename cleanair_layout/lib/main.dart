import 'package:flutter/material.dart';
import 'BusinessLogic/database/db.dart';
import 'Screens/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Air main',
      home: MainLayout(
      ),
    );
  }
}
