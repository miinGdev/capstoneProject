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
  bool isEditing = false;
  late TextEditingController _controller;

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
        _controller = TextEditingController(text: summary);
      });
    } else {
      setState(() {
        summary = "❌ 요약 실패: ${response.statusCode}";
        _controller = TextEditingController(text: summary);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(); // 초기화 (fetch 전용)
    fetchSummary();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.day}일의 일기"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (isEditing)
              Expanded(
                child: TextField(
                  controller: _controller,
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  keyboardType: TextInputType.multiline,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "일기를 입력하세요",
                  ),
                  style: const TextStyle(fontSize: 18),
                ),
              ) else
                Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        summary,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                ),
              ],
            ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                if (isEditing) {
                  summary = _controller.text; // 저장
                } else {
                  _controller.text = summary;
                }
                isEditing = !isEditing; // 모드 전환
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => states.contains(MaterialState.pressed)
                    ? Colors.black.withOpacity(0.7)
                    : Colors.black,
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: Text(
              isEditing ? "저장" : "수정하기",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}