import 'package:flutter/material.dart';

class ScheduleInput extends StatefulWidget {
  final Function(String) onSave;

  const ScheduleInput({super.key, required this.onSave});

  @override
  _ScheduleInputState createState() => _ScheduleInputState();
}

class _ScheduleInputState extends State<ScheduleInput> {
  final TextEditingController _controller = TextEditingController();

  void _saveSchedule() {
    if (_controller.text.isNotEmpty) {
      widget.onSave(_controller.text);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 150,
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: "일정 입력",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveSchedule,
            child: const Text("저장"),
          ),
        ],
      ),
    );
  }
}
