import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF22C55E);
    const navyBlue = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'baddal',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryGreen),
                ),
                const SizedBox(height: 30),
                const Text('تسجيل الدخول', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navyBlue)),
                const SizedBox(height: 8),
                const Text('مرحباً بك مجدداً في baddal', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 35),

                // حقل البريد الإلكتروني
                _buildFieldLabel('البريد الإلكتروني أو اسم المستخدم'),
                TextField(
                  textAlign: TextAlign.right,
                  decoration: _buildInputDecoration(Icons.email_outlined, 'example@baddal.com'),
                ),
                const SizedBox(height: 20),

                // حقل كلمة المرور
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFieldLabel('كلمة المرور'),
                    TextButton(
                      onPressed: () {},
                      child: const Text('نسيت كلمة المرور؟', style: TextStyle(color: primaryGreen, fontSize: 12)),
                    ),
                  ],
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.right,
                  decoration: _buildInputDecoration(Icons.visibility_outlined, '••••••••'),
                ),
                
                const SizedBox(height: 25),
                const Text('أو عبر رقم الهاتف', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 15),

                // حقل رقم الهاتف المطور (مصر +20)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_drop_down, color: navyBlue),
                          SizedBox(width: 4),
                          Text('EG +20', style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        decoration: _buildInputDecoration(null, '010 0000 0000'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                // زر دخول
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('دخول', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 30),
                const Text('تسجيل سريع عبر', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 15),

                // أزرار جوجل وآبل المعدلة لتكون نظيفة وأنيقة تماماً
                Row(
                  children: [
                    Expanded(child: _buildSocialButton('Google', Icons.g_mobiledata_rounded)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSocialButton('Apple', Icons.apple)),
                  ],
                ),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('ليس لديك حساب؟ ', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                      },
                      child: const Text('إنشاء حساب جديد', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
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
        child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF0F172A))),
      ),
    );
  }

  InputDecoration _buildInputDecoration(IconData? prefixIcon, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[500]) : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF22C55E))),
    );
  }

  Widget _buildSocialButton(String label, IconData icon) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.black87),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }
}