import 'package:flutter/material.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Courses',
        style: TextStyle(
          color: Colors.black,fontSize: 18,
          fontWeight: FontWeight.bold
        ),),
        backgroundColor: Colors.white,
        leading: Container(
          decoration:BoxDecoration(
            color: Colors.blue,
            

          ) ,
        ),
        
      ),
    );
  }
}