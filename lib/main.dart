import 'package:flutter/material.dart';
import 'package:sudoku/view/selection_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromARGB(255, 66, 67, 146),
        scaffoldBackgroundColor: Color.fromARGB(255, 27, 27, 27),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SelectionPage(),
    );
  }
}
