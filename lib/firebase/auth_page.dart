import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Auth Page (Login / Register)',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
