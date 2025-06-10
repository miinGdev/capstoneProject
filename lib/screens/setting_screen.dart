import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isUnderlined = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 배경 없음
        elevation: 0, // 그림자 제거
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black), // X 아이콘
          onPressed: () {
            Navigator.pop(context); // 현재 화면 닫기
          },
        ),
      ),
      backgroundColor: Colors.grey.shade200, // 이미지 배경색 비슷하게
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 👈 왼쪽 정렬
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 16), // 👈 여백 추가
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isUnderlined = !isUnderlined;
                });
              },
              child: Text(
                "사용 가이드",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  decoration: isUnderlined
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}