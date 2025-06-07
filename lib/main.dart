import 'package:flutter/material.dart';
import 'screens/purpose_selection_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'On the Record',
      initialRoute: '/',
      routes: {
        '/': (context) => const PurposeSelectionScreen(),
        '/chat': (context) => const ChatScreen(),
      },
    );
  }
}
