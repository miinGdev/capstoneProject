//diaryDate를 받아와서 node.js에 diary 요청 -> diary받아와서 diaryDate에 맞도록 출력

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DiaryScreen extends StatefulWidget {
  final int day;
  final DateTime diaryDate; // 날짜 전달 추가

  const DiaryScreen({super.key, required this.day, required this.diaryDate});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  String summary = "일기를 불러오는 중...";
  bool isEditing = false;
  late TextEditingController _controller;

  Future<void> fetchDiary() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id") ?? "unknown";

    final date = "${widget.diaryDate.year.toString().padLeft(4, '0')}-"
        "${widget.diaryDate.month.toString().padLeft(2, '0')}-"
        "${widget.diaryDate.day.toString().padLeft(2, '0')}";

    final uri = Uri.parse("http://210.125.91.93:3000/diary?user_id=$userId&date=$date");

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        summary = data["diary"];
        _controller = TextEditingController(text: summary);
      });
    } else {
      setState(() {
        summary = "❌ 일기 불러오기 실패: ${response.statusCode}";
        _controller = TextEditingController(text: summary);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    fetchDiary();
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
        title: Text("${widget.diaryDate.year}-${widget.diaryDate.month.toString().padLeft(2, '0')}-${widget.diaryDate.day.toString().padLeft(2, '0')} 일기"),
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
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    summary,
                    style: const TextStyle(fontSize: 18),
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
                  summary = _controller.text;
                } else {
                  _controller.text = summary;
                }
                isEditing = !isEditing;
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
