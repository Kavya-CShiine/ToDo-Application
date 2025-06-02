import 'package:flutter/material.dart';
import 'package:flutter_application_1/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Widget> isAlreadyLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionId = prefs.getString('sessionId');
    final username = prefs.getString('username') ?? '';
    if (sessionId != null) return HomePage(username: username);
    return const LoginPage();
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:FutureBuilder<Widget>(
                    future: isAlreadyLogin(),
                    builder: (context, AsyncSnapshot<Widget> initSnapshot) {
                      if (initSnapshot.connectionState ==
                          ConnectionState.done) {
                        return initSnapshot.data!;
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? sessionId;
  
  

  Future<void> _handleLogin() async {

    
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    final url = Uri.parse('http://localhost:3000/login'); 

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password, 'rememberMe': rememberMe}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          sessionId = data['sessionId'];
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('sessionId', sessionId!);
        
        final username = usernameController.text.trim();
        await prefs.setString('username', username);
        final Password = usernameController.text.trim();
        await prefs.setString('password', password);
        
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(username: username),
          ),
        );
      } else {
        _showErrorDialog("Login Failed", response.body);
      }
    } catch (e) {
      _showErrorDialog("Error", e.toString());
    }
  }

  @override
void initState() {
  super.initState();
  fetchRememberedUser();
}

Future<void> fetchRememberedUser() async {
  try {
    final response = await http.get(Uri.parse('http://localhost:3000/remembered-user'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        usernameController.text = data['username'] ?? '';
        passwordController.text = data['password'] ?? '';
      });
    }
  } catch (e) {
    // Optional: Handle error
    print('Error fetching remembered user: $e');
  }
}


  Future<void> _showErrorDialog(String title, String content) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 244, 101, 91),
      ),
      body: Center(
        child: Container(
          width: 400,
          height: 300,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.cyanAccent.withAlpha(77),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 24),
              CheckboxListTile(
               title: const Text("Remember Me"),
                value: rememberMe,
                onChanged: (value) {
                setState(() {
                rememberMe = value!;
                   });
                  },
                 ),

              
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 244, 101, 91),
                  foregroundColor: Colors.black,
                ),
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


