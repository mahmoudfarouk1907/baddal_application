// lib/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'otp_screen.dart'; // استدعاء شاشة الـ OTP بنجاح

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 1️⃣ دالة التحقق الصارمة من البريد الإلكتروني (أصبح إجباري لتفعيل الـ OTP المجاني)
  String? _validateEmail(String? value) {
    String email = (value ?? '').trim();
    if (email.isEmpty) {
      return 'البريد الإلكتروني إجباري لإنشاء الحساب وتفعيل الـ OTP';
    }
    final regExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regExp.hasMatch(email)) {
      return 'صيغة البريد الإلكتروني غير صحيحة (يجب أن يكون بالإنجليزية)';
    }
    return null;
  }

  // 2️⃣ دالة التحقق الذكية من رقم الهاتف (أصبح اختياري، لكن لو اتكتب لازم يكون 11 رقم مصري صح)
  String? _validatePhoneNumber(String? value) {
    String phone = (value ?? '').trim();
    if (phone.isEmpty) {
      return null; // مسموح بتركه فارغاً بناءً على طلبك الجديد 🎯
    }
    final regExp = RegExp(r'^01[0125]\d{8}$');
    if (!regExp.hasMatch(phone)) {
      return 'رقم هاتف مصري غير صحيح (يجب أن يبدأ بـ 010, 011, 012, 015 ويتكون من 11 رقم)';
    }
    return null;
  }

  // 3️⃣ دالة التحقق من كلمة المرور (تمنع الحروف العربية نهائياً وتتحقق من الطول)
  String? _validatePassword(String? value) {
    String pass = value ?? '';
    if (pass.isEmpty) {
      return 'يرجى تعيين كلمة مرور لحماية حسابك';
    }
    if (pass.length < 6) {
      return 'كلمة المرور ضعيفة (يجب ألا تقل عن 6 أحرف أو أرقام)';
    }
    // منع الحروف العربية تماماً ومطابقة شروط صفحة الـ Login
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: navyBlue, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'BADDAL',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryGreen, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 25),
                  const Text('إنشاء حساب جديد', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: navyBlue)),
                  const SizedBox(height: 6),
                  Text('انضم إلى مجتمع بدل وابدأ رحلتك اليوم', style: TextStyle(color: textHighContrast, fontSize: 15, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 30),

                  // حقل الاسم الكامل
                  _buildFieldLabel('الاسم الكامل'),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: navyBlue, fontWeight: FontWeight.w600),
                    validator: (value) => value == null || value.trim().isEmpty ? 'يرجى إدخال الاسم الكامل' : null,
                    decoration: _buildInputDecoration(Icons.person_outline, 'أدخل اسمك بالكامل', navyBlue),
                  ),
                  const SizedBox(height: 18),

                  // حقل البريد الإلكتروني (إجباري للـ OTP المجاني)
                  _buildFieldLabel('البريد الإلكتروني (تفعيل الـ OTP)'),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: navyBlue, fontWeight: FontWeight.w600),
                    validator: _validateEmail, 
                    decoration: _buildInputDecoration(Icons.email_outlined, 'email@example.com', navyBlue),
                  ),
                  const SizedBox(height: 18),

                  // حقل رقم الهاتف (اختياري وبدون تعقيد كود الدولة)
                  _buildFieldLabel('رقم الهاتف المحمول (اختياري)'),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    validator: _validatePhoneNumber, 
                    style: const TextStyle(color: navyBlue, fontWeight: FontWeight.w600, fontSize: 16),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: _buildInputDecoration(Icons.phone_android_rounded, '01xxxxxxxxx (يمكن تركه فارغاً)', navyBlue).copyWith(
                      counterText: "",
                    ),
                  ),
                  const SizedBox(height: 18),

                  // حقل كلمة المرور
                  _buildFieldLabel('كلمة المرور'),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: navyBlue, fontWeight: FontWeight.w600),
                    validator: _validatePassword, 
                    decoration: _buildInputDecoration(Icons.lock_outline, '••••••••', navyBlue),
                  ),
                  
                  const SizedBox(height: 35),
                  
                  // زر إنشاء الحساب المحدث لتمرير الداتا كاملة وبشكل ديناميكي لشاشة الـ OTP
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          
                          // تمرير البيانات الحقيقية التي أدخلها المستخدم شاشة الـ OTP عبر الإيميل
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                phone: _phoneController.text.trim(),
                                name: _nameController.text.trim(),
                                email: _emailController.text.trim(),
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('إنشاء حساب', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 25),
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