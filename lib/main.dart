import 'package:flutter/material.dart';
import 'package:on_the_record/screens/calendar_screen.dart';
import 'screens/purpose_selection_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/home_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/purpose_selection_screen.dart';
import 'screens/setting_screen.dart';
import 'screens/onboarding_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'On the Record',
      initialRoute: '/',
      routes: {
        //'/': (context) => const LoginScreen(),
        '/': (context) => const HomeScreen(),
        '/chat': (context) => const ChatScreen(),
        '/cal' : (context) => const CalendarScreen(),
        '/set' : (context) => const SettingScreen(),
        '/onboarding' : (context) => const OnboardingScreen(),
      },
    );
  }
}