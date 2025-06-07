import 'package:flutter/material.dart';
import 'emoji_selector.dart';
import 'schedule_input.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  Map<DateTime, String> emojiRecords = {};
  Map<DateTime, String> scheduleRecords = {};

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });

    _showEmojiDialog(date);
  }

  void _showEmojiDialog(DateTime date) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return EmojiSelector(
          onEmojiSelected: (emoji) {
            setState(() {
              emojiRecords[date] = emoji;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _showScheduleDialog(DateTime date) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ScheduleInput(
          onSave: (schedule) {
            setState(() {
              scheduleRecords[date] = schedule;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("캘린더"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            "${selectedDate.month}월 ${selectedDate.year}",
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
                DateTime date = DateTime(selectedDate.year, selectedDate.month, index + 1);

                return GestureDetector(
                  onTap: () => _selectDate(date),
                  onLongPress: () => _showScheduleDialog(date),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.purple.shade100,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${index + 1}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          emojiRecords[date] ?? "🙂",
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
