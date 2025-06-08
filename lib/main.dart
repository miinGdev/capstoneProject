import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:on_the_record/screens/calendar_screen.dart';
import 'screens/purpose_selection_screen.dart';
import 'screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart'; 
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/purpose_selection_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'On the Record',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/chat': (context) => const ChatScreen(),
        '/signup': (context) => const SignupScreen(),
        '/cal' : (context) => const CalendarScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}