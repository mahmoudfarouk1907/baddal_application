// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'signup_screen.dart';
import 'main_layout.dart';
import 'captain_orders_screen.dart'; // الحاضن أو الشاشة الخاصة بالكابتن

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
  bool _isLoading = false; // لمؤشر التحميل عند ضرب الـ API

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
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    if (arabicRegex.hasMatch(pass)) {
      return 'كلمة المرور يجب أن تكون بالإنجليزية أو الأرقام/الرموز فقط وممنوع العربي';
    }
    return null;
  }

  // 🌐 3️⃣ دالة تسجيل الدخول والربط مع الـ API (جاهزة للربط الفوري)
  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    
    // مسح أمني شامل قبل تخزين بيانات الجلسة الجديدة
    await prefs.clear(); 

    String email = _emailController.text.trim().toLowerCase();
    String password = _passwordController.text;

    try {
      // -------------------------------------------------------------
      // 💡 مكان ربط الـ API الخاص بك مستقبلاً:
      // final response = await myApi.login(email: email, password: password);
      // String serverRole = response.data['role']; // كابتن أو يوزر عادي
      // String token = response.data['token'];
      // String userName = response.data['name'];
      // String userPhone = response.data['phone'] ?? '';
      // -------------------------------------------------------------

      // 🧪 بيئة الاختبار الحالية وتوجيه الأدوار الذكي (Demo Accounts)
      if (email == "ad@g.com") {
        await _saveSession(prefs, role: 'main_admin', email: email, name: 'الأدمن الرئيسي');
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminPanelScreen()));
      } 
      else if (email == "adcash@g.com") {
        await _saveSession(prefs, role: 'cash_admin', email: email, name: 'أدمن الخزنة والكاش');
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDepositsDashboard()));
      } 
      else if (email == "cap@gmail.com") {
        // حساب الكابتن التجريبي الثابت
        await _saveSession(prefs, role: 'captain', email: email, name: 'كابتن مصطفى نصر', phone: '01012345678');
        if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CaptainMainLayout()));
      } 
      else {
        // السلوك الديناميكي: هنا نقدر نفرق بناءً على الداتا المرتجعة من السيرفر
        // كمثال للاختبار الحالي: لو الإيميل بيحتوي على كلمة "captain" هيعتبره كابتن، غير كده يوزر عادي
        if (email.contains("captain")) {
          await _saveSession(prefs, role: 'captain', email: email, name: 'كابتن بدّال الجديد', phone: '01199998888');
          if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CaptainMainLayout()));
        } else {
          await _saveSession(prefs, role: 'user', email: email, name: 'مستخدم بدّال');
          if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainLayout()));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ أثناء تسجيل الدخول: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // دالة مساعدة لتخزين الجلسة لتجنب تكرار الكود
  Future<void> _saveSession(SharedPreferences prefs, {required String role, required String email, required String name, String phone = ''}) async {
    await prefs.setString('user_role', role);
    await prefs.setString('user_email', email);
    await prefs.setString('user_name', name);
    if (phone.isNotEmpty) {
      await prefs.setString('user_phone', phone);
    }
    await prefs.setBool('is_logged_in', true);
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
          child: PlatformDetails.isBusy(_isLoading)
              ? const Center(child: CircularProgressIndicator(color: primaryGreen))
              : SingleChildScrollView(
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
                            onPressed: _handleLogin,
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

class PlatformDetails {
  static bool isBusy(bool state) => state;
}