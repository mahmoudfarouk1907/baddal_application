// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'signup_screen.dart';
import 'main_layout.dart';
import 'captain_orders_screen.dart'; 

// استيراد لوحات التحكم الصحيحة والمطابقة لملفات مشروعك الحالية
import 'admin_deposits_dashboard.dart';
import 'admin_panel_screen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 1️⃣ فاليديشن حقل الإيميل (إجباري وصارم ويقبل الإدارة أو أي مستخدم عادي بصيغة صحيحة)
  String? _validateEmail(String? value) {
    String email = (value ?? '').trim().toLowerCase();

    if (email.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني الخاص بك';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}');
    if (!emailRegex.hasMatch(email)) {
      return 'صيغة البريد الإلكتروني غير صحيحة (يجب كتابته بالإنجليزية)';
    }
    
    return null;
  }

  // 2️⃣ فاليديشن كلمة المرور (تمنع العربي وتتحقق من الطول والرموز)
  String? _validatePassword(String? value) {
    String pass = value ?? '';
    if (pass.isEmpty) {
      return 'كلمة المرور إجبارية لتسجيل الدخول';
    }
    if (pass.length < 6) {
      return 'كلمة المرور يجب ألا تقل عن 6 أحرف أو أرقام';
    }
    // منع الحروف العربية تماماً (تقبل حروف إنجليزية، أرقام، رموز)
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    if (arabicRegex.hasMatch(pass)) {
      return 'كلمة المرور يجب أن تكون بالإنجليزية أو الأرقام/الرموز فقط وممنوع العربي';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF22C55E);
    const navyBlue = Color(0xFF0F172A);
    final textHighContrast = navyBlue.withValues(alpha: 0.7);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text('baddal', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: primaryGreen)),
                  const SizedBox(height: 30),
                  const Text('تسجيل الدخول', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: navyBlue)),
                  const SizedBox(height: 8),
                  Text('مرحباً بك مجدداً في baddal', style: TextStyle(color: textHighContrast, fontSize: 15, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 40),

                  _buildFieldLabel('البريد الإلكتروني'),
                  TextFormField(
                    controller: _emailController,
                    validator: _validateEmail, 
                    style: const TextStyle(color: navyBlue, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration(Icons.email_outlined, 'example@baddal.com', navyBlue),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFieldLabel('كلمة المرور'),
                      TextButton(
                        onPressed: () {},
                        child: const Text('نسيت كلمة المرور؟', style: TextStyle(color: primaryGreen, fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: _validatePassword, 
                    obscureText: true,
                    style: const TextStyle(color: navyBlue, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                    decoration: _buildInputDecoration(Icons.lock_outline, '••••••••', navyBlue),
                  ),
                  
                  const SizedBox(height: 45),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          final prefs = await SharedPreferences.getInstance();
                          
                          // مسح أمني شامل قبل تخزين بيانات الجلسة الجديدة
                          await prefs.clear(); 
                          
                          String email = _emailController.text.trim().toLowerCase();

                          // 👑 1. الأدمن الرئيسي
                          if (email == "ad@g.com") {
                            await prefs.setString('user_role', 'main_admin');
                            await prefs.setString('user_email', email);
                            await prefs.setString('user_name', 'الأدمن الرئيسي');
                            await prefs.setBool('is_logged_in', true);
                            
                            if (mounted) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminPanelScreen()));
                            }
                          }
                          // 💵 2. أدمن مراجعة الكاش
                          else if (email == "adcash@g.com") {
                            await prefs.setString('user_role', 'cash_admin');
                            await prefs.setString('user_email', email);
                            await prefs.setString('user_name', 'أدمن الخزنة والكاش');
                            await prefs.setBool('is_logged_in', true);
                            
                            if (mounted) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDepositsDashboard()));
                            }
                          }
                          // 🏍️ 3. حساب الكابتن
                          else if (email == "cap@gmail.com") {
                            await prefs.setString('user_role', 'captain');
                            await prefs.setString('user_email', email);
                            await prefs.setString('user_name', 'كابتن مصطفى نصر');
                            await prefs.setBool('is_logged_in', true);
                            
                            if (mounted) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CaptainMainLayout()));
                            }
                          } 
                          // 👤 4. مستخدم عادي (يسجل بأي إيميل بره حسابات الإدارة)
                          else {
                            await prefs.setString('user_role', 'user');
                            await prefs.setString('user_email', email);
                            // بنخزن اسم افتراضي للمستخدم لحد ما يغيره من بروفايله
                            await prefs.setString('user_name', 'مستخدم بدّال');
                            await prefs.setBool('is_logged_in', true);
                            
                            if (mounted) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainLayout()));
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen, 
                        elevation: 0, 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('دخول', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ليس لديك حساب؟ ', style: TextStyle(color: textHighContrast, fontWeight: FontWeight.w500)),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen())),
                        child: const Text('إنشاء حساب جديد', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerRight, 
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0), 
        child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
      ),
    );
  }

  InputDecoration _buildInputDecoration(IconData? prefixIcon, String hint, Color navy) {
    return InputDecoration(
      hintText: hint, 
      hintStyle: TextStyle(color: navy.withValues(alpha: 0.4), fontSize: 14, fontWeight: FontWeight.w400),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: navy.withValues(alpha: 0.6)) : null,
      filled: true, 
      fillColor: Colors.white, 
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      errorStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[400]!, width: 1.2)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF22C55E), width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1.2)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
    );
  }
}