import 'package:flutter/material.dart';
import 'package:flutter_application_1/signup/notes/colors.dart';
import 'package:flutter_application_1/signup/notes/pages/notes.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' Awesome Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(238, 255, 252, 252),
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
          backgroundColor: const Color.fromARGB(0, 121, 16, 16),
        titleTextStyle: TextStyle(color:primary, fontSize: 32, 
        fontFamily: 'Italic',
        fontWeight: FontWeight.bold
        ),
        ),
      ),
      home: const Notes(),
    );
}
}
