import 'package:flutter/material.dart';
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
                  final username = usernameController.text;
                  final password = passwordController.text;
            
                  print('Username: $username');
                  print('Password: $password');

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Homescreen()),
                    ((route) => false)
                  );
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
