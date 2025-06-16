//DiaryTimescreen 수정본

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat_screen.dart';

class DiaryTimeScreen extends StatefulWidget {
  const DiaryTimeScreen({super.key});

  @override
  State<DiaryTimeScreen> createState() => _DiaryTimeScreenState();
}

class _DiaryTimeScreenState extends State<DiaryTimeScreen> {
  TimeOfDay? _selectedTime;

  void _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveAndNavigate() async {
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("일기 시간을 선택해주세요.")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id");

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("로그인 정보가 없습니다.")),
      );
      return;
    }

    final diaryTime = "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}";

    try {
      final response = await http.post(
        Uri.parse("http://210.125.91.93:3000/diaryTime"), // ← IP 주소 실제 서버 주소로 바꿔야 함
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "diaryTime": diaryTime  // ✅ 변수명 정확히 일치
        }),
      );

      if (response.statusCode == 200) {
        await prefs.setString("diaryTime", diaryTime); // 로컬에도 저장
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("서버 저장 실패: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("서버 연결 실패: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("일기 시간 선택")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("일기를 시작할 시간을 설정해주세요", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 24),
              Text(
                _selectedTime == null
                    ? "시간을 선택해주세요"
                    : "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selectTime,
                child: const Text("시간 선택"),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveAndNavigate,
                child: const Text("확인"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}