import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiaryScreen extends StatefulWidget {
  final int day;

  const DiaryScreen({super.key, required this.day});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  String summary = "요약을 불러오는 중...";
  final List<List<String>> history = [
    ["user", "오늘은 기분이 아주 좋았다. 친구와 점심을 함께 했다."],
    ["assistant", "그랬구나! 기분 좋았겠다!"],
    ["user", "맞아. 날씨도 좋았어."]
  ];

  Future<void> fetchSummary() async {
    final uri = Uri.parse("http://210.125.91.93:8000/summary");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "message": "무시됨",
        "tone": "기본",
        "history": history
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        summary = data["response"];
      });
    } else {
      setState(() {
        summary = "❌ 요약 실패: ${response.statusCode}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("📓 ${widget.day}일의 일기"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          summary,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}