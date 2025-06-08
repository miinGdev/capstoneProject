import 'package:flutter/material.dart';
import 'home_screen.dart';

class PurposeSelectionScreen extends StatelessWidget {
  const PurposeSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("On the Record의 사용 목적"),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPurposeButton(context, '일기'),
            const SizedBox(height: 16),
            _buildPurposeButton(context, '일정 관리'),
            const SizedBox(height: 16),
            _buildPurposeButton(context, '기분 기록'),
          ],
        ),
      ),
    );
  }

  Widget _buildPurposeButton(BuildContext context, String label) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 48),
        backgroundColor: Colors.brown,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
