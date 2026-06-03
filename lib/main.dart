import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // استدعاء شاشتنا المخصصة

void main() {
  runApp(const BaddalApp());
}

class BaddalApp extends StatelessWidget {
  const BaddalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'بدال',
      debugShowCheckedModeBanner: false,
      // الثيم الفاتح
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF22C55E),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      // الثيم الداكن
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF22C55E),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      themeMode: ThemeMode.system, // يتغير مع وضع الموبايل تلقائياً
      home: const LoginScreen(), // الشاشة التي ستفتح أول ما التطبيق يشتغل
    );
  }
}