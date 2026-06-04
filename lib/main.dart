import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart'; // تأكد من صحة المسار عندك في المشروع

void main() {
  runApp(const BaddalApp());
}

class BaddalApp extends StatelessWidget {
  const BaddalApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color customDarkBlue = Color(0xFF0F172A);
    const Color primaryGreen = Color(0xFF22C55E);

    return MaterialApp(
      title: 'بدال',
      debugShowCheckedModeBanner: false,
      
      // --- الثيم الفاتح (Light Theme) الموحد عالي التباين ---
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryGreen,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        
        // تظبيط الخطوط (TextTheme)
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: customDarkBlue, fontWeight: FontWeight.w600, fontSize: 16),
          bodyMedium: TextStyle(color: customDarkBlue, fontWeight: FontWeight.w500, fontSize: 14),
          titleLarge: TextStyle(color: customDarkBlue, fontWeight: FontWeight.bold, fontSize: 22),
          titleMedium: TextStyle(color: customDarkBlue, fontWeight: FontWeight.bold, fontSize: 18),
        ),

        // تظبيط حقول الإدخال (InputDecorationTheme) لتقرأ تلقائياً في كل الصفحات
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(color: customDarkBlue, fontWeight: FontWeight.w600),
          hintStyle: TextStyle(color: customDarkBlue.withOpacity(0.4), fontSize: 14, fontWeight: FontWeight.w400),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          errorStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primaryGreen, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),

        // تظبيط الأزرار بشكل موحد (ElevatedButtonTheme)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            elevation: 0,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),

      // --- الثيم الداكن (Dark Theme) ---
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryGreen,
        scaffoldBackgroundColor: customDarkBlue,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),

      themeMode: ThemeMode.system, 
      home: const OnboardingScreen(),
    );
  }
}