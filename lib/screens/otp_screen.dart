import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_layout.dart'; // الإمبورت الجديد للحاضن الأساسي بالـ Nav Bar

class OtpScreen extends StatefulWidget {
  final String destination; // تستقبل الرقم أو الإيميل ديناميكياً

  const OtpScreen({super.key, required this.destination});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final _formKey = GlobalKey<FormState>();
  
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navyBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'رمز التحقق (OTP)',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: navyBlue),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'تم إرسال كود التفعيل المكون من 4 أرقام إلى:\n${widget.destination}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: navyBlue.withValues(alpha: 0.7), fontWeight: FontWeight.w600, height: 1.5),
                  ),
                  const SizedBox(height: 40),

                  // مربعات إدخال الـ OTP الـ 4 المتجاوبة
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 60,
                        child: TextFormField(
                          controller: _controllers[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: navyBlue),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 3) {
                              FocusScope.of(context).nextFocus(); // الانتقال التلقائي للمربع التالي
                            } else if (value.isEmpty && index > 0) {
                              FocusScope.of(context).previousFocus(); // الرجوع للمربع السابق عند الحذف
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[400]!, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: primaryGreen, width: 2.5),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),

                  // زر التحقق والتأكيد النهائى المتصل بالـ MainLayout
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        bool isComplete = _controllers.every((c) => c.text.isNotEmpty);
                        if (isComplete) {
                          // تصفير كل الصفحات القديمة والانتقال للـ MainLayout مباشرة لمنع اختفاء الـ Nav Bar
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const MainLayout()),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('يرجى ملء جميع خانات رمز التحقق أولاً', style: TextStyle(fontWeight: FontWeight.bold))),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('تأكيد والذهاب للرئيسية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('لم يصلك الرمز؟ ', style: TextStyle(color: navyBlue.withValues(alpha: 0.7), fontWeight: FontWeight.w500)),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إعادة إرسال الرمز بنجاح')));
                        },
                        child: const Text('إعادة إرسال', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 15)),
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
}