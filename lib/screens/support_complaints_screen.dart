import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // 1. استيراد الحزمة الجديدة هنا

class SupportComplaintsScreen extends StatefulWidget {
  const SupportComplaintsScreen({super.key});

  @override
  State<SupportComplaintsScreen> createState() => _SupportComplaintsScreenState();
}

class _SupportComplaintsScreenState extends State<SupportComplaintsScreen> {
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color backgroundColor = Color(0xFFF8FAFC);

  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();
  
  String? _selectedCategory;
  final List<String> _categories = [
    "تأخر الكابتن في التوصيل",
    "مشكلة في الحساب أو القيمة المالية",
    "سلوك غير لائق من الكابتن",
    "مشكلة تقنية داخل تطبيق بدال",
    "أخرى"
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  // 2. الفانكشن المعدلة لإرسال الإيميل مباشرة
  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("يرجى اختيار نوع المشكلة أولاً", style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // تجهيز بيانات الإيميل
      final String email = 'baddal.support@gmail.com';
      final String subject = Uri.encodeComponent('بلاغ دعم فني - تطبيق بدال: $_selectedCategory');
      final String body = Uri.encodeComponent('تفاصيل البلاغ:\n${_detailsController.text}');
      
      final Uri emailUri = Uri.parse('mailto:$email?subject=$subject&body=$body');

      try {
        // محاولة فتح تطبيق الإيميل على جهاز المستخدم
        if (await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: Colors.white),
                  SizedBox(width: 12),
                  Text("جاري فتح تطبيق البريد لإرسال بلاغك للإدارة...", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              backgroundColor: primaryGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );

          // تنظيف الحقول بعد التوجيه الناجح
          _detailsController.clear();
          setState(() {
            _selectedCategory = null;
          });
        } else {
          throw 'Could not launch email app';
        }
      } catch (e) {
        // لو الجهاز مفيش فيه تطبيق إيميل أو حصل خطأ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("عذراً، لم نتمكن من فتح تطبيق البريد. يمكنك مراسلتنا مباشرة على baddal.support@gmail.com", style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("الدعم الفني والشكاوى", style: TextStyle(color: navyBlue, fontWeight: FontWeight.w900, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navyBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: primaryGreen.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(12)),
                  child: const Row(
                    children: [
                      Icon(Icons.headset_mic_rounded, color: primaryGreen, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "مرحباً بك في مركز مساعدة بدال. نحن هنا لحل أي مشكلة واجهتك، يرجى ملء البيانات وسيتم فتح البريد الإلكتروني لإرسالها مباشرة للإدارة.",
                          style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 13, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text("نوع المشكلة أو الشكوى", style: TextStyle(fontWeight: FontWeight.w900, color: navyBlue, fontSize: 14)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  dropdownColor: Colors.white,
                  hint: Text("اختر تصنيف المشكلة...", style: TextStyle(color: navyBlue.withValues(alpha: 0.35), fontWeight: FontWeight.bold, fontSize: 14)),
                  items: _categories.map((cat) => DropdownMenuItem(
                    value: cat, 
                    child: Text(
                      cat, 
                      style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 14),
                    ),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: primaryGreen, size: 28),
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 20),
                const Text("تفاصيل المشكلة بالكامل", style: TextStyle(fontWeight: FontWeight.w900, color: navyBlue, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _detailsController,
                  maxLines: 5,
                  maxLength: 300,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 14),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "يرجى كتابة تفاصيل المشكلة";
                    if (v.trim().length < 10) return "يرجى كتابة وصف أكثر وضوحاً (10 أحرف على الأقل)";
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "يرجى كتابة ما حدث معك بالتفصيل (رقم الرحلة، وقت الحدوث، إلخ...)",
                    hintStyle: TextStyle(color: navyBlue.withValues(alpha: 0.35), fontWeight: FontWeight.w500, fontSize: 13),
                    fillColor: Colors.white,
                    filled: true,
                    errorStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                    contentPadding: const EdgeInsets.all(16),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryGreen, width: 2)),
                    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
                    focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navyBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: _submitComplaint,
                    child: const Text("إرسال البلاغ للإدارة", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      errorStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryGreen, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
    );
  }
}