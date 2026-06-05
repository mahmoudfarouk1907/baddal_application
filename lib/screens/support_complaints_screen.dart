import 'package:flutter/material.dart';

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

  void _submitComplaint() {
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
      
      // محاكاة إرسال البيانات للـ Backend بنجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 12),
              Text("تم إرسال بلاغك بنجاح وجاري مراجعته من الإدارة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          backgroundColor: primaryGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      _detailsController.clear();
      setState(() {
        _selectedCategory = null;
      });
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
                // نص ترحيبي توضيحي
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: primaryGreen.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                  child: const Row(
                    children: [
                      Icon(Icons.headset_mic_rounded, color: primaryGreen, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "مرحباً بك في مركز مساعدة بدال. نحن هنا لحل أي مشكلة واجهتك، يرجى ملء البيانات وسيتم التواصل معك خلال 24 ساعة.",
                          style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 13, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // حقل اختيار نوع المشكلة (تم تصليحه بالكامل)
                const Text("نوع المشكلة أو الشكوى", style: TextStyle(fontWeight: FontWeight.w900, color: navyBlue, fontSize: 14)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  dropdownColor: Colors.white, // التعديل الجوهري: يخلي القائمة المنسدلة بيضاء ناصعة لما تفتح
                  hint: Text("اختر تصنيف المشكلة...", style: TextStyle(color: navyBlue.withOpacity(0.35), fontWeight: FontWeight.bold, fontSize: 14)),
                  // تأكيد تلوين النص بالـ navyBlue بوضوح لكل عنصر داخل القائمة
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

                // حقل كتابة تفاصيل الشكوى
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
                    hintStyle: TextStyle(color: navyBlue.withOpacity(0.35), fontWeight: FontWeight.w500, fontSize: 13),
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

                // زر إرسال الشكوى
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