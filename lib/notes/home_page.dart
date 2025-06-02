import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../login_page.dart';

class HomePage extends StatelessWidget {
  final String sessionId;

  HomePage({required this.sessionId});

  Future<void> _logoutUser(String sessionId, BuildContext context) async {
    final url = Uri.parse('http://localhost:3000/'); // replace <your-ip> with your Node.js server IP

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'sessionId': sessionId}),
    );

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      // Handle successful logout
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
      
      // Clear the sessionId from secure storage
      final FlutterSecureStorage secureStorage = FlutterSecureStorage();
      await secureStorage.delete(key: 'sessionId');

      // Navigate to Login Page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['error'] ?? 'Logout failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _logoutUser(sessionId, context);
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
