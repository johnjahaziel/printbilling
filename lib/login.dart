import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:printer/homescreen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final url = Uri.parse('https://billing.1bluetooth.com/api/login');

    try {

      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Homescreen()),
          ((route) => false)
        );

        Fluttertoast.showToast(msg: responseData['message']);
      } else {
        Fluttertoast.showToast(msg: responseData['message']);

        print(responseData);
      }

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      
          const Text(
            'Login',
            style: TextStyle(
              fontSize: 20
            ),
          ),

          const SizedBox(height: 16),
      
          /// Username
          Center(
            child: SizedBox(
              width: 350,
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
          ),
      
          const SizedBox(height: 16),
      
          /// Password
          Center(
            child: SizedBox(
              width: 350,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ),
          ),
      
          const SizedBox(height: 24),
      
          /// Login Button
          Center(
            child: SizedBox(
              width: 350,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  _handleLogin();
                },
                child: const Text('Login'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
