import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> sendMessage(String userMessage) async {
    setState(() {
      messages.add({"role": "user", "content": userMessage});
    });

    final response = await http.post(
      Uri.parse("http://210.125.91.93:8000/rag-chat"), // 실제 서버 주소
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
                          ? Colors.blueAccent.withOpacity(0.8)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      isUser
                          ? "${msg["content"]}"
                          : "${msg["content"]}",
                        style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
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
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "메시지를 입력하세요",
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
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
