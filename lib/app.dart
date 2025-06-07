import 'package:flutter/material.dart';
import 'screens/purpose_selection_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'On the Record',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      initialRoute: '/purpose_selection',
      routes: {
        '/purpose_selection': (context) => const PurposeSelectionScreen(),
        '/calendar': (context) => const CalendarScreen(),
        '/chat': (context) => const ChatScreen(),
      },
    );
  }
}
