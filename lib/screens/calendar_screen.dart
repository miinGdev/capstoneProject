import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'diary_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<int, String> emotionData = {}; // 날짜별 이모지 저장

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
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text("감정 캘린더"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            "${now.year}년 ${now.month}월",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: 31,
              itemBuilder: (context, index) {
                final day = index + 1;
                final emoji = emotionData[day] ?? "🙂";

                return GestureDetector(
                  onTap: () => _onDayTapped(day),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.teal.shade100,
                    ),
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
                          style: const TextStyle(fontSize: 24),
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