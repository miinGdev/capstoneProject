import 'package:flutter/material.dart';
import 'package:on_the_record/screens/diary_time_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen.dart';
import 'diary_time_screen.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _controller = TextEditingController();

  void _submitName() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("이름을 입력해주세요.")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getString("user_id");

    // ✅ 기존 user_id와 다르면 is_first_launch 초기화
    if (storedUserId != null && storedUserId != name) {
      await prefs.setBool("is_first_launch", true);
    }

    // ✅ user_id 및 diary_date 저장
    await prefs.setString("user_id", name);
    await prefs.setString("diary_date", DateTime.now().toIso8601String());

    final isFirstLaunch = prefs.getBool("is_first_launch") ?? true;

    if (isFirstLaunch) {
      await prefs.setBool("is_first_launch", false); // 다음부터는 false로
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DiaryTimeScreen()),
      );
    } else {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ChatScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "On the Record에서\n사용할 당신의 이름을\n알려주세요!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitName,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("등록", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}