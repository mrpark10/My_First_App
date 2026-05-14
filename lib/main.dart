// 앱이 시작되는 입구.
// runApp 으로 MoodBoardApp 을 띄우고, 그 안에서 HomeScreen 을 보여줍니다.

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MoodBoardApp());
}

class MoodBoardApp extends StatelessWidget {
  const MoodBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '우리반 감정 리포트',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFBBF24)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
