// lib/screens/captain_support_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaptainSupportScreen extends StatefulWidget {
  const CaptainSupportScreen({super.key});

  @override
  State<CaptainSupportScreen> createState() => _CaptainSupportScreenState();
}

class _CaptainSupportScreenState extends State<CaptainSupportScreen> {
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color backgroundColor = Color(0xFFF8FAFC);

  final _formKey = GlobalKey<FormState>();
  final _transactionController = TextEditingController();
  final _notesController = TextEditingController();
  
  bool _isImageSelected = false; // محاكاة لرفع الصورة
  bool _isSubmitting = false;

  @override
  void dispose() {
    _transactionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // دالة محاكاة رفع الإيصال وتصفير المحفظة في الكاش
  Future<void> _submitReceipt() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_isImageSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ يرجى إرفاق صورة إيصال التحويل أولاً!"),
          backgroundColor: Colors.amber,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // محاكاة وقت الرفع للسيرفر (ثانيتين)
    await Future.delayed(const Duration(seconds: 2));

    // السحر البرمجي: تصفير المحفظة وإلغاء البلوك في الكاش
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('captain_wallet_balance', 0.0);
    await prefs.setBool('is_captain_blocked', false);

    setState(() {
      _isSubmitting = false;
    });

    if (mounted) {
      // إظهار رسالة نجاح مريحة للكابتن
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ تم إرسال الإيصال للإدارة بنجاح! جاري مراجعته وتصفير حسابك فوراً ⏱️"),
          backgroundColor: primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      // الرجوع لشاشة المحفظة أوتوماتيك بعد النجاح
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "إرسال إيصال التوريد",
          style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: navyBlue),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _isSubmitting
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: primaryGreen),
                    SizedBox(height: 16),
                    Text("جاري رفع البيانات وتأكيد الطلب...", style: TextStyle(color: navyBlue, fontWeight: FontWeight.w500)),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // بنر توضيحي علوي
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.verified_user_rounded, color: Colors.blue),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "تأكيد التحويل: املأ البيانات بالأسفل ليرسل الأبلكيشن الإثبات لوحة تحكم الإدارة وتفعيل حسابك تلقائياً.",
                                style: TextStyle(color: navyBlue, fontSize: 13, height: 1.4, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // 1. مكان رفع الإيصال (الـ Image Picker التخيلي)
                      const Text(
                        "صورة إيصال التحويل (سكرين شوت أو صورة الإيصال) *",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: navyBlue),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isImageSelected = true; // تفعيل إن الصورة اترفت للتجربة
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("📸 تم اختيار صورة الإيصال من معرض الصور بنجاح!"), duration: Duration(seconds: 1)),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                            color: _isImageSelected ? Colors.green.withOpacity(0.04) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isImageSelected ? primaryGreen : Colors.grey.shade300, 
                              style: _isImageSelected ? BorderStyle.solid : BorderStyle.none // بيبان داشد لو لسه مرفعش
                            ),
                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.03), blurRadius: 10)],
                          ),
                          child: _isImageSelected
                              ? const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle_rounded, color: primaryGreen, size: 48),
                                    SizedBox(height: 8),
                                    Text("تم إرفاق إيصال التحويل بنجاح!", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                                    SizedBox(height: 4),
                                    Text("اضغط لإعادة الاختيار", style: TextStyle(color: Colors.grey, fontSize: 11)),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload_outlined, color: Colors.grey.shade400, size: 48),
                                    const SizedBox(height: 8),
                                    const Text("اضغط هنا لرفع صورة الإيصال", style: TextStyle(color: navyBlue, fontWeight: FontWeight.w500, fontSize: 13)),
                                    const SizedBox(height: 4),
                                    const Text("يدعم صيغ JPG, PNG أو لقطات الشاشة", style: TextStyle(color: Colors.grey, fontSize: 11)),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 2. حقل رقم العملية
                      const Text(
                        "رقم العملية أو الرقم المحول منه *",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: navyBlue),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _transactionController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "مثال: 010xxxxxxx أو رقم مرجعي",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: primaryGreen, width: 1.5)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "الرجاء إدخال رقم العملية للتأكيد";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // 3. ملاحظات إضافية
                      const Text(
                        "ملاحظات إضافية للإدارة (اختياري)",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: navyBlue),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: "اكتب هنا أي تفاصيل إضافية تريد إبلاغ الإدارة بها...",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade200)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: primaryGreen, width: 1.5)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // زر الإرسال النهائي
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryGreen,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          onPressed: _submitReceipt,
                          child: const Text(
                            "تأكيد وإرسال الإيصال للإدارة 🚀",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}