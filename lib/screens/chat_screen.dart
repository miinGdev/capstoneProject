import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'calendar_screen.dart';
import 'setting_screen.dart';

import 'package:on_the_record/screens/calendar_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  //List<Map<String, String>> messages = [{"role": "user", "content": "넌 user가 요청하는대로 말투랑 대답 형식을 맞춰야 돼."}];

  //String selectedTone = '집사';

  /*Future<String> fetchRagResponse(String query) async {
    final uri = Uri.parse("http://210.125.91.93:8000/rag");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"query": query}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      return json["response"];
    } else {
      return "❌ 오류: ${response.statusCode}";
    }
  }*/

  late stt.SpeechToText _speech;
  bool _isListening = false;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _controller.text = result.recognizedWords;
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _speak(String text) async {
    await _tts.setLanguage("ko-KR");
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.9);
    await _tts.speak(text);
  }

  Future<void> sendMessage(String userMessage) async {
    setState(() {
      messages.add({"role": "user", "content": userMessage});
    });

    final response = await http.post(
      Uri.parse("http://10.0.2.2:3000/chat"),
      // Uri.parse("http://210.125.91.93:8000/rag-chat"), // 실제 서버 주소
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"messages": messages}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        messages.add({"role": "assistant", "content": decoded["response"]});
      });
    } else {
      print("❌ 서버 응답 실패: ${response.body}");
    }
  }


  /*void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userInput = _controller.text;

    setState(() {
      messages.add({"role": "user", "content": userInput});
      _controller.clear();
    });

    final reply = await fetchRagMessage(userInput);

    setState(() {
      messages.add({"role": "assistant", "content": reply});
    });
  }*/

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    final input = _controller.text;
    _controller.clear();
    sendMessage(input);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ✅ 왼쪽에 설정 아이콘 버튼 추가
        /*leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingScreen()),
            );
          },
        ), */
        // ✅ 오른쪽 캘린더 아이콘은 기존대로 유지
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icon_calendar.svg',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarScreen()),
                );
              },
            ),
          ),
        ],
        title: const Text("GPT 챗봇"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg["role"] == "user";
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.grey.shade200
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            msg["content"],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        if (!isUser) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.speaker, size: 20),
                            onPressed: () => _speak(msg["content"]),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: _isListening ? Colors.black : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      icon: const Icon(Icons.mic),
                      color: _isListening ? Colors.white : Colors.black54,
                      onPressed: _listen,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "메시지를 입력하세요",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 14.0,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                _isListening
                  ? IconButton(
                      icon: const Icon(Icons.stop_circle),
                      tooltip: "음성인식 정지 및 전송",
                      onPressed: () {
                      _speech.stop();
                      setState(() => _isListening = false);
                      _sendMessage();
                      _controller.clear();
                      },
                    )
                    : IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
    ],
    ),
    ),
        ],
      ),
    );
  }
}
