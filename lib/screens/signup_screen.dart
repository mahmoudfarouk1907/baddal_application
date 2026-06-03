import 'package:flutter/material.dart';
import 'home_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF22C55E);
    const navyBlue = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: navyBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Text(
                  'BADDAL',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryGreen, letterSpacing: 1.5),
                ),
                const SizedBox(height: 30),
                const Text('إنشاء حساب جديد', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navyBlue)),
                const SizedBox(height: 6),
                const Text('انضم إلى مجتمع بدل وابدأ رحلتك اليوم', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 30),

                _buildFieldLabel('الاسم الكامل'),
                TextField(decoration: _buildInputDecoration(Icons.person_outline, 'أدخل اسمك بالكامل')),
                const SizedBox(height: 16),

                _buildFieldLabel('البريد الإلكتروني'),
                TextField(decoration: _buildInputDecoration(Icons.email_outlined, 'email@example.com')),
                const SizedBox(height: 16),

                _buildFieldLabel('رقم الهاتف'),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: const Text('EG +20', style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(decoration: _buildInputDecoration(null, '50 000 0000')),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildFieldLabel('كلمة المرور'),
                TextField(obscureText: true, decoration: _buildInputDecoration(Icons.lock_outline, '••••••••')),
                
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
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
    );
  }

  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
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
}