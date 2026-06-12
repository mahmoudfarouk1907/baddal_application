// lib/main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart'; 
import 'screens/login_screen.dart';
import 'screens/main_layout.dart';
import 'screens/captain_orders_screen.dart'; // هذا الملف يحتوي الآن على الـ Layout المجمع للكابتن


void main() async {
  // للتأكد من أن كود الفلاتر جاهز قبل قراءة الـ SharedPreferences على الويب
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
  final String? userRole = prefs.getString('user_role'); // كابتن أو يوزر
  final String? userEmail = prefs.getString('user_email'); // 👈 قرأنا الإيميل هنا للتأكد من وجود تسجيل دخول فعلي

  runApp(MyApp(seenOnboarding: seenOnboarding, userRole: userRole, userEmail: userEmail));
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  final String? userRole;
  final String? userEmail; // 👈 مررنا الإيميل للـ Widget
  const MyApp({super.key, required this.seenOnboarding, this.userRole, this.userEmail});

  @override
  Widget build(BuildContext context) {
    const Color customDarkBlue = Color(0xFF0F172A);
    const Color primaryGreen = Color(0xFF22C55E);

    // الـ Logic المسؤول عن توجيه المستخدم من البداية تماماً 🚀
    Widget getHomeScreen() {
      // 1. لو لسه مستخدم جديد خالص وما شافش الـ Onboarding، يروح لشاشات التعريف
      if (!seenOnboarding) return const OnboardingScreen();
      
      // 2. لو شاف الـ Onboarding ودخل كـ كابتن، يروح للـ Layout المجمع الجديد (الطلبات والمحفظة والبروفايل)
      if (userRole == 'captain') return const CaptainMainLayout(); 
      
      // 3. 🚨 التعديل الرسمي للتفنيش:
      // مستحيل يدخل لشاشات اليوزر (MainLayout) إلا لو كان الرول يوزر وكمان الإيميل بتاعه متسجل فعلياً
      if (userRole == 'user' && (userEmail?.isNotEmpty ?? false)) {
        return const MainLayout();
      }
      
      // 4. لو مفيش أي رول متسجل أو اليوزر مش عامل تسجيل دخول حقيقي (null)، يروح لشاشة اللوج إن مباشرة 🔐
      return const LoginScreen(); 
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Baddal',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryGreen,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: customDarkBlue, fontWeight: FontWeight.w600, fontSize: 16),
          bodyMedium: TextStyle(color: customDarkBlue, fontWeight: FontWeight.w500, fontSize: 14),
          titleLarge: TextStyle(color: customDarkBlue, fontWeight: FontWeight.bold, fontSize: 22),
          titleMedium: TextStyle(color: customDarkBlue, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: customDarkBlue, fontWeight: FontWeight.w600),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryGreen, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: getHomeScreen(),
    );
  }
}