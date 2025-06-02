import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Make status bar icons light (white) — suitable for dark backgrounds
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.purple, // Match AppBar color
    statusBarIconBrightness: Brightness.light, // Android
    statusBarBrightness: Brightness.dark, // iOS
  ));

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(
          'Appbar Demo',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: false,
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
        flexibleSpace: SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 60.0, top: 8),
              child: Icon(Icons.camera, size: 20),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Container(
            color: Colors.grey,
            height: 30,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              "CShiine Technologies",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
      drawer: buildDrawer(),
      endDrawer: buildDrawer(),
      body: Center(
        child: Text(
          'Demo body content',
          style: TextStyle(
            fontSize: 29,
            color: Colors.red,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Inbox',
            icon: Icon(Icons.inbox_outlined),
          ),
        ],
        onTap: (int index) {
          print(index.toString());
        },
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      elevation: 20,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Kavya R'),
            accountEmail: Text('kavya.r@cshiine.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text('K'),
            ),
          ),
          buildDrawerItem('All inboxes', Icons.mail),
          buildDrawerItem('Inbox', Icons.inbox_outlined),
          buildDrawerItem('Starred', Icons.star_border),
          buildDrawerItem('Snoozed', Icons.snooze_outlined),
          buildDrawerItem('Sent', Icons.send_outlined),
          buildDrawerItem('Scheduled', Icons.schedule),
          buildDrawerItem('Outbox', Icons.outbox_outlined),
        ],
      ),
    );
  }

  Widget buildDrawerItem(String title, IconData icon) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: Icon(icon),
        ),
        Divider(height: 0.1),
      ],
    );
  }
}
