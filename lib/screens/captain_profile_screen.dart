// lib/screens/captain_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // استدعاء شاشة اللوجن

class CaptainProfileScreen extends StatefulWidget {
  const CaptainProfileScreen({super.key});

  @override
  State<CaptainProfileScreen> createState() => _CaptainProfileScreenState();
}

class _CaptainProfileScreenState extends State<CaptainProfileScreen> {
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);

  final TextEditingController _phoneController = TextEditingController();
  final String _savedEmail = "cap@g.com"; 
  String _savedPhone = "لم يتم ربط رقم هاتف بعد";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCaptainData();
  }

  Future<void> _loadCaptainData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPhone = prefs.getString('captain_phone') ?? "لم يتم ربط رقم هاتف بعد";
      if (_savedPhone != "لم يتم ربط رقم هاتف بعد") {
        _phoneController.text = _savedPhone;
      }
      _isLoading = false;
    });
  }

  Future<void> _linkPhoneToEmail() async {
    if (_phoneController.text.isEmpty || _phoneController.text.length < 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("برجاء إدخال رقم هاتف صحيح مكون من 11 رقم 📱"), backgroundColor: Colors.red),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('captain_phone', _phoneController.text);
    
    setState(() {
      _savedPhone = _phoneController.text;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ تم ربط رقم الهاتف بحسابك بنجاح!"), backgroundColor: primaryGreen),
      );
    }
  }

  // دالة تسجيل الخروج القاطعة باستخدام rootNavigator
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("تسجيل الخروج", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue)),
        content: const Text("هل أنت متأكد أنك تريد تسجيل الخروج؟", textAlign: TextAlign.center),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text("إلغاء")),
          TextButton(
            onPressed: () async {
              // 1. صفر الذاكرة تماماً وامسح الـ user_role
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear(); 

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("تم الخروج بنجاح 👋"), backgroundColor: navyBlue),
                );

                // 2. قفل الـ Dialog برضه من الـ root
                Navigator.of(dialogContext, rootNavigator: true).pop();

                // 3. التوجيه الصاروخي برة الـ Bottom Navigation Bar تماماً ونفض الـ History
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text("خروج", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("حساب الكابتن الشخصي", style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryGreen))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CircleAvatar(radius: 50, backgroundColor: primaryGreen.withValues(alpha: 0.1), child: const Icon(Icons.sports_motorsports_rounded, size: 60, color: primaryGreen)),
                  const SizedBox(height: 16),
                  const Text("كابتن تطبيق بدال", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: navyBlue)),
                  Text(_savedEmail, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [Icon(Icons.phone_android_rounded, color: primaryGreen), SizedBox(width: 8), Text("ربط رقم الموبايل بالحساب", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue))]),
                        const SizedBox(height: 8),
                        Text("الرقم الحالي: $_savedPhone", style: const TextStyle(fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 11,
                          decoration: InputDecoration(hintText: "أدخل رقم الموبايل الجديد", counterText: "", contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: primaryGreen), onPressed: _linkPhoneToEmail, child: const Text("تأكيد الربط بالإيميل", style: TextStyle(color: Colors.white))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
                    child: ListTile(onTap: _handleLogout, leading: const Icon(Icons.logout_rounded, color: Colors.red), title: const Text("تسجيل الخروج", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)), trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16)),
                  ),
                ],
              ),
            ),
    );
  }
}