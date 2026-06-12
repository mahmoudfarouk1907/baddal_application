// edit_profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 🔢 إمبورت أساسي للتحكم في مدخلات الكيبورد والـ Formatters
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart'; // 📸 مكتبة اختيار الصور

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _imagePath; // 🔑 متغير لحفظ مسار الصورة الشخصية المختار حياً
  final ImagePicker _picker = ImagePicker();

  static const Color navyBlue = Color(0xFF0F172A); 
  static const Color primaryGreen = Color(0xFF22C55E);

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData(); // 🔄 جلب بيانات المستخدم الحقيقية فور فتح الشاشة
  }

  // 🔄 دالة جلب البيانات الحالية من الـ SharedPreferences
  Future<void> _loadCurrentUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? "";
      _phoneController.text = prefs.getString('user_phone') ?? "";
      _imagePath = prefs.getString('user_image'); // جلب مسار الصورة لو موجود
    });
  }

  // 📸 دالة اختيار صورة شخصية من استوديو الهاتف
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  // 💾 دالة حفظ كافة البيانات (الاسم، الصورة، ورقم الهاتف) مباشرة في الكاش بدون OTP
  Future<void> _saveProfileData() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      
      // حفظ البيانات مباشرة
      await prefs.setString('user_name', _nameController.text.trim());
      await prefs.setString('user_phone', _phoneController.text.trim());
      
      if (_imagePath != null) {
        await prefs.setString('user_image', _imagePath!);
      }

      if (mounted) {
        _showCustomSnackBar("عملية ناجحة", "تم تحديث وحفظ بيانات الملف الشخصي بنجاح.", primaryGreen);
        // إغلاق الشاشة والرجوع بعد الحفظ المباشر ليرى المستخدم النتيجة في البروفايل
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.pop(context);
        });
      }
    }
  }

  // ميثود موحدة لإظهار الـ SnackBar الاحترافي الخاص بك باللون المختار
  void _showCustomSnackBar(String title, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              Icon(
                title == "عملية ناجحة" ? Icons.check_circle_rounded : Icons.info_rounded, 
                color: Colors.white, 
                size: 26,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xE6FFFFFF), fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), 
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
                // --- قسم تعديل الصورة الشخصية الحية ---
                Center(
                  child: GestureDetector(
                    onTap: _pickImage, // عند الضغط يفتح الاستوديو فوراً
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50, 
                          backgroundColor: Colors.grey.shade200, 
                          backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
                          child: _imagePath == null 
                              ? const Icon(Icons.person, size: 50, color: Colors.grey)
                              : null,
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
                  maxLength: 11, // 🛑 قفل كامل: يمنع كتابة أكتر من 11 رقم في الخانة
                  style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 16),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // 🔢 يسمح بالأرقام فقط ويمنع الرموز أو الحروف
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "رقم الموبيل مطلوب";
                    }
                    // 🔍 فحص دقيق لطول الرقم (11 رقم بالظبط) والتحقق من بدايات الشبكات المصرية
                    final regExp = RegExp(r'^01[0125][0-9]{8}$');
                    if (!regExp.hasMatch(v.trim())) {
                      return "أدخل رقم هاتف مصري صحيح مكون من 11 رقم";
                    }
                    return null;
                  },
                  decoration: _inputDecoration(Icons.phone_android_rounded, "01xxxxxxxxx").copyWith(
                    counterText: "", // 👁️ إخفاء العداد التلقائي للحفاظ على جمال الديزاين
                  ),
                ),
                const SizedBox(height: 40),

                // 💾 زر حفظ التعديلات النهائي الذكي والمباشر (باللون الأخضر المعتمد)
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen, 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), 
                      elevation: 0
                    ),
                    onPressed: _saveProfileData,
                    icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                    label: const Text(
                      "حفظ وتحديث البيانات الشخصية", 
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
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

  InputDecoration _inputDecoration(IconData icon, String hintText) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: primaryGreen, size: 22),
      hintText: hintText,
      hintStyle: TextStyle(color: navyBlue.withValues(alpha: 0.4), fontWeight: FontWeight.w500),
      fillColor: Colors.white,
      filled: true,
      errorStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), 
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.6)
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
  static const FontWeight boldFont = FontWeight.w800; 
}