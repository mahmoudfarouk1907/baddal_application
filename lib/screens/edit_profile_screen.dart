import 'package:flutter/material.dart';
// إستيراد صفحة الـ OTP القديمة الخاصة بك (تأكد من كتابة المسار الصحيح للملف عندك)
import 'otp_screen.dart'; 

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: "أحمد محمد");
  final _phoneController = TextEditingController(text: "01012345678");
  final _formKey = GlobalKey<FormState>();

  // ألوان ثابتة وصريحة لأعلى تباين بصري (High Contrast)
  static const Color navyBlue = Color(0xFF0F172A); // كحلي داكن جداً وواضح
  static const Color primaryGreen = Color(0xFF22C55E);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ميثود الانتقال للـ OTP مع انتظار النتيجة وإظهار الرسالة بتصميمها الجديد
  void _verifyAndGoToOTP() async {
    if (_formKey.currentState!.validate()) {
      // الانتظار حتى يعود المستخدم من صفحة الـ OTP
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const OtpScreen(destination: '/profile'),
        ),
      );

      // إظهار الـ SnackBar الاحترافي الجديد فور العودة
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded, 
                    color: Colors.white, 
                    size: 26,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "عملية ناجحة",
                          style: TextStyle(
                            fontWeight: FontWeight.w900, 
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "تم حفظ البيانات وتغيير الرقم بنجاح.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            color: Color(0xE6FFFFFF),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: primaryGreen,
            behavior: SnackBarBehavior.floating, // تطفو بشكل مودرن فوق العناصر
            margin: const EdgeInsets.all(16), // أبعاد احترافية عن الحواف
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // حواف دائرية ناعمة
            ),
            elevation: 4,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // خلفية بيضاء صريحة ونظيفة
      appBar: AppBar(
        title: const Text(
          "تعديل البيانات الشخصية", 
          style: TextStyle(color: navyBlue, fontWeight: PlatformColors.boldFont, fontSize: 19),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navyBlue), 
          onPressed: () => Navigator.pop(context)
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- قسم تعديل الصورة ---
                Center(
                  child: GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("جاري فتح الاستوديو لرفع صورة..."))
                    ),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50, 
                          backgroundColor: Colors.grey.shade200, 
                          child: const Icon(Icons.person, size: 50, color: Colors.grey)
                        ),
                        const Positioned(
                          bottom: 0, 
                          right: 0, 
                          child: CircleAvatar(
                            radius: 16, 
                            backgroundColor: primaryGreen, 
                            child: Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white)
                          )
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // --- حقل الاسم بالكامل ---
                const Padding(
                  padding: EdgeInsets.only(bottom: 8, right: 4),
                  child: Text(
                    "الاسم بالكامل", 
                    style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 16)
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 16),
                  validator: (v) => (v == null || v.trim().isEmpty) ? "الاسم مطلوب" : null,
                  decoration: _inputDecoration(Icons.person_outline_rounded, "أدخل الاسم بالكامل"),
                ),
                const SizedBox(height: 24),

                // --- حقل رقم الموبيل ---
                const Padding(
                  padding: EdgeInsets.only(bottom: 8, right: 4),
                  child: Text(
                    "رقم الموبيل", 
                    style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 16)
                  ),
                ),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 16),
                  validator: (v) => (v == null || v.length < 11) ? "أدخل رقم هاتف صحيح مكون من 11 رقم" : null,
                  decoration: _inputDecoration(Icons.phone_android_rounded, "01xxxxxxxxx"),
                ),
                const SizedBox(height: 40),

                // --- زر حفظ التعديلات والانتقال للـ OTP ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen, 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
                      elevation: 0
                    ),
                    onPressed: _verifyAndGoToOTP,
                    child: const Text(
                      "حفظ وتأكيد عبر رمز OTP", 
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)
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

  // ميثود الديكورشن لثبات تباين الحقول والخطوط لضعاف النظر
  InputDecoration _inputDecoration(IconData icon, String hintText) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: primaryGreen, size: 22),
      hintText: hintText,
      hintStyle: TextStyle(color: navyBlue.withOpacity(0.4), fontWeight: FontWeight.w500),
      fillColor: Colors.white,
      filled: true,
      errorStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.6) // حدود بارزة
      ), 
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: const BorderSide(color: primaryGreen, width: 2.2)
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: const BorderSide(color: Colors.red, width: 1.6)
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: const BorderSide(color: Colors.red, width: 2.2)
      ),
    );
  }
}

class PlatformColors {
  static const FontWeight boldFont = FontWeight.w800; // خط عريض جداً ومثالي للـ AppBar
}