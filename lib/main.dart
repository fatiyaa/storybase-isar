import 'package:after_ets/pages/home-page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoryBase',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: HomePage(),  // Set HomePage as the initial route
    );
  }
}
