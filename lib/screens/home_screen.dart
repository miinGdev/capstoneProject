// home_screen.dart - Home Screen Implementation

import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On the Record'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMenuButton(context, '대화하기', '/chat'),
            const SizedBox(height: 16),
            _buildMenuButton(context, '일정 관리', '/calendar'),
            const SizedBox(height: 16),
            _buildMenuButton(context, '기분 기록', '/calendar'),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String text, String route) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        backgroundColor: Colors.black,
      ),
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
