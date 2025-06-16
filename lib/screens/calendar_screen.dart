import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'chat_screen.dart';
import 'diary_screen.dart';
import 'setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<int, String> emotionData = {};
  int? _selectedDay;
  DateTime _currentMonth = DateTime.now();

  String emotionToEmoji(String emotion) {
    switch (emotion) {
      case "긍정":
        return "😊";
      case "보통":
        return "😐";
      case "부정":
        return "😢";
      default:
        return "🙂";
    }
  }

  Future<void> fetchEmotionMap() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id") ?? "unknown";
    final year = _currentMonth.year;
    final month = _currentMonth.month;

    final uri = Uri.parse(
        "http://210.125.91.93:3000/calendarEmotion?user_id=$userId&year=$year&month=$month");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      Map<int, String> temp = {};

      for (final item in data["emotions"]) {
        final date = DateTime.parse(item["date"]);
        if (date.year == year && date.month == month) {
          final int day = date.day;
          final finalEmotion = item["finalEmotion"];
          temp[day] = emotionToEmoji(finalEmotion);
        }
      }

      setState(() {
        emotionData = temp;
      });
    }
  }

  int daysInMonth(DateTime date) {
    final year = date.year;
    final month = date.month;
    if (month == 12) return 31;
    final firstDayThisMonth = DateTime(year, month, 1);
    final firstDayNextMonth = DateTime(year, month + 1, 1);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  void _onDayTapped(int day) {
    final date = DateTime(_currentMonth.year, _currentMonth.month, day);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiaryScreen(
          day: day,
          diaryDate: date,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchEmotionMap();
  }

  @override
  Widget build(BuildContext context) {
    final days = daysInMonth(_currentMonth);
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startWeekday = firstDay.weekday % 7; // ✅ 수정된 부분: 일요일 시작 기준
    final totalItems = startWeekday + days;

    return Scaffold(
      appBar: AppBar(
        title: const Text("감정 캘린더"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: SvgPicture.asset('assets/icon_chat.svg', width: 24, height: 24),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ChatScreen()));
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
                      fetchEmotionMap();
                    });
                  },
                ),
                Text("${_currentMonth.year}년 ${_currentMonth.month}월",
                    style: const TextStyle(fontSize: 24)),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    setState(() {
                      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                      fetchEmotionMap();
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
                Expanded(child: Center(child: Text("일", style: TextStyle(fontSize: 16)))),
                Expanded(child: Center(child: Text("월", style: TextStyle(fontSize: 16)))),
                Expanded(child: Center(child: Text("화", style: TextStyle(fontSize: 16)))),
                Expanded(child: Center(child: Text("수", style: TextStyle(fontSize: 16)))),
                Expanded(child: Center(child: Text("목", style: TextStyle(fontSize: 16)))),
                Expanded(child: Center(child: Text("금", style: TextStyle(fontSize: 16)))),
                Expanded(child: Center(child: Text("토", style: TextStyle(fontSize: 16)))),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cellWidth = constraints.maxWidth / 7;
                final cellHeight = cellWidth * 1.1;

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: totalItems,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: cellWidth / cellHeight,
                  ),
                  itemBuilder: (context, index) {
                    if (index < startWeekday) {
                      return const SizedBox.shrink();
                    }
                    final day = index - startWeekday + 1;
                    final emoji = emotionData[day] ?? "🙂";

                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedDay = day);
                        _onDayTapped(day);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: _selectedDay == day
                              ? Colors.grey.shade300
                              : Colors.white,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("$day", style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(emoji, style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}