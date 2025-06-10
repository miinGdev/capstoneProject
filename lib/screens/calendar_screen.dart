import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'chat_screen.dart';
import 'diary_screen.dart';
import 'setting_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<int, String> emotionData = {}; // 날짜별 이모지 저장
  int? _selectedDay;
  DateTime _currentMonth = DateTime.now();

  // 감정 분석 API 호출
  Future<String> analyzeEmotion(String text) async {
    final uri = Uri.parse("http://210.125.91.93:8000/emotion");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "message": text,
        "tone": "기본",
        "history": []
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return data["response"]; // 긍정 / 부정 / 보통
    } else {
      return "분석 실패";
    }
  }

  // 감정 → 이모지
  String emotionToEmoji(String emotion) {
    switch (emotion) {
      case "긍정":
        return "😊";
      case "보통":
        return "😐";
      case "부정":
        return "😢";
      default:
        return "😊";
    }
  }

  // 월별 날짜 수 계산 함수
  int daysInMonth(DateTime date) {
    final year = date.year;
    final month = date.month;

    if (month == 12) {
      return 31;
    }

    final firstDayThisMonth = DateTime(year, month, 1);
    final firstDayNextMonth = DateTime(year, month + 1, 1);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  // 날짜 탭 시 샘플 텍스트 분석 후 이모지 저장
  void _onDayTapped(int day) async {
    // final sampleText = "오늘 너무 힘들었어. 친구랑 다투고 과제도 많았어."; // 샘플
    // final emotion = await analyzeEmotion(sampleText);
    setState(() {
      emotionData[day] = "😐";
      //emotionToEmoji(emotion)
    });

    // 일기 보기로 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DiaryScreen(day: day)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final days = daysInMonth(_currentMonth); // 현재 월의 총 날짜 수

    return Scaffold(
      appBar: AppBar(
        /*leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingScreen()),
            );
          },
        ),*/
        title: const Text("감정 캘린더"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icon_chat.svg',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
                    });
                  },
                ),
                Text(
                  "${_currentMonth.year}년 ${_currentMonth.month}월",
                  style: const TextStyle(fontSize: 24),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(child: Center(child: Text("일", style: const TextStyle(fontSize: 16),))),
                Expanded(child: Center(child: Text("월", style: const TextStyle(fontSize: 16),))),
                Expanded(child: Center(child: Text("화", style: const TextStyle(fontSize: 16),))),
                Expanded(child: Center(child: Text("수", style: const TextStyle(fontSize: 16),))),
                Expanded(child: Center(child: Text("목", style: const TextStyle(fontSize: 16),))),
                Expanded(child: Center(child: Text("금", style: const TextStyle(fontSize: 16),))),
                Expanded(child: Center(child: Text("토", style: const TextStyle(fontSize: 16),))),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: days,
              itemBuilder: (context, index) {
                final day = index + 1;
                final emoji = emotionData[day] ?? "🙂";

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDay = day;
                    });
                    _onDayTapped(day);
                  },
                  child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _selectedDay == day ? Colors.grey.shade300 : Colors.white,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(
                  "$day",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                  emoji,
                  style: const TextStyle(fontSize: 20),
                  ),
                  ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}