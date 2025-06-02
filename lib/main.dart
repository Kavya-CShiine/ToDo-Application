import 'package:flutter/material.dart';


import 'package:flutter_application_1/whatsapp/tabs/call.dart';
import 'package:flutter_application_1/whatsapp/tabs/camera.dart';
import 'package:flutter_application_1/whatsapp/tabs/chats.dart';
import 'package:flutter_application_1/whatsapp/tabs/status.dart';


void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
     
     
        home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Whatsapp',
        style: TextStyle(
          color: Colors.white,),
        ), 
        backgroundColor: Color(0xff075e54),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.white), 
            onPressed: () {  },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white), onPressed: () {  },
          ),
        ],
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: <Widget>[
  Tab(
    icon: Icon(
      Icons.camera_alt,
      color: Colors.white,
    ),
  ),
  Tab(
    child: Text(
      'CHATS',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
  Tab(
    child: Text(
      'STATUS',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
  Tab(
    child: Text(
      'CALL',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Camera(),
          Chats(),
          Status(),
          Call(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () {  },
              child: Icon(Icons.camera, color: Colors.white),
            )
          : _tabController.index == 1
              ? FloatingActionButton(
                  onPressed: () {  },
                  child: Icon(Icons.message, color: Colors.white),
                )
              : _tabController.index == 2
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        SizedBox(
                          height: 45.0,
                          width: 45.0,
                          child: FloatingActionButton(
                            backgroundColor: Colors.white,
                            onPressed: () {  },
                            child: Icon(Icons.edit, color: Colors.blueGrey),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        FloatingActionButton(
                          onPressed: () {  },
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        )
                      ],
                    )
                  : FloatingActionButton(
                      onPressed: () {  },
                      child: Icon(Icons.add_call, color: Colors.white),
                    ),
    );
  }
}
