import 'package:flutter/material.dart';
import 'payment_confirmation_screen.dart';

class SupermarketScreen extends StatefulWidget {
  const SupermarketScreen({super.key});

  @override
  State<SupermarketScreen> createState() => _SupermarketScreenState();
}

class _SupermarketScreenState extends State<SupermarketScreen> {
  final _listController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int selectedOption = 0; // 0: داخل المدينة، 1: خارج المدينة
  int get price => selectedOption == 0 ? 25 : 40;

  // الألوان الموحدة للمشروع (High Contrast & Clean UI)
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  void _submitOrder() {
    // الفحص الذكي: التأكد من كتابة الطلبات قبل الانتقال لصفحة الدفع
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentConfirmationScreen(
            totalAmount: price,
            method: "vodafone",
            serviceName: "طلبات السوبرماركت",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // خلفية نظيفة وموحدة
      appBar: AppBar(
        title: const Text(
          "طلبات السوبرماركت",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // لضبط اتجاه العناصر بالكامل للغة العربية
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    "قائمة المشتريات",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: navyBlue),
                  ),
                ),

                // بوكس إدخال الطلبات مع الـ Validation الداخلي
                TextFormField(
                  controller: _listController,
                  maxLines: 5,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: navyBlue, fontSize: 15),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? "يرجى كتابة قائمة المشتريات أولاً"
                      : null,
                  decoration: InputDecoration(
                    hintText: "اكتب هنا كل اللي محتاجه (مثلاً: 2 كيلو سكر، كرتونة بيض، منظفات...)",
                    hintStyle: TextStyle(color: navyBlue.withValues(alpha: 0.4), fontSize: 14, fontWeight: FontWeight.w500),
                    fillColor: Colors.white,
                    filled: true,
                    errorStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: primaryGreen, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.red, width: 1.2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // --- ملحوظة الوزن بتصميم Minimalist هادي وأنيق ---
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100, // خلفية رمادية هادية
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primaryGreen.withValues(alpha: 0.2), width: 1), // تحديد أخضر خفيف
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: primaryGreen, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "أي منتج وزنه فوق 3 كجم (مثل كراتين المياه) يتم إضافة 10 ج رسوم شحن إضافية.",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: navyBlue.withValues(alpha: 0.8),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    "نطاق التوصيل",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: navyBlue),
                  ),
                ),

                // بوكس خيارات التوصيل بتصميم نظيف وفاصل ناعم
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300, width: 1.2),
                  ),
                  child: Column(
                    children: [
                      RadioListTile<int>(
                        activeColor: primaryGreen,
                        title: const Text(
                          "داخل المدينة (25 جنيه)",
                          style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 15),
                        ),
                        value: 0,
                        groupValue: selectedOption,
                        onChanged: (val) => setState(() => selectedOption = val!),
                      ),
                      // الفاصل الناعم والمريح للعين بديل الخط الأسود القديم
                      Divider(color: Colors.grey.shade100, height: 1, thickness: 1.5),
                      RadioListTile<int>(
                        activeColor: primaryGreen,
                        title: const Text(
                          "خارج المدينة (40 جنيه)",
                          style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 15),
                        ),
                        value: 1,
                        groupValue: selectedOption,
                        onChanged: (val) => setState(() => selectedOption = val!),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // زر تأكيد الطلب
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _submitOrder,
                    child: Text(
                      "تأكيد الطلب ($price ج.م)",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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