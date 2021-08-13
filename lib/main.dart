import 'package:flutter/material.dart';
import './app/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainPage(),
    );
  }
}
