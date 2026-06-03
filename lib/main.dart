import 'package:baddal_application/onboarding_screen.dart';
import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:baddal_application/screens/login_screen.dart';

void main() async {
  // للتأكد من تهيئة كل الـ Widgets قبل قراءة الذاكرة
  WidgetsFlutterBinding.ensureInitialized();
  
  // فحص هل المستخدم فتح التطبيق قبل كده؟
  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

  runApp(MyApp(seenOnboarding: seenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  const MyApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Baddal',
      // الشرط السحري: لو شافها قبل كده يفتح اللوج إن، لو أول مرة يفتح الـ Onboarding
      home: seenOnboarding ? const LoginScreen() : OnboardingScreen(),
    );
  }
}