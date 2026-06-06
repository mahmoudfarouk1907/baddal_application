import 'package:flutter/material.dart';
import 'payment_confirmation_screen.dart';

class PharmacyScreen extends StatefulWidget {
  const PharmacyScreen({super.key});

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  final _medicineController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // متغير وهمي لمحاكاة رفع الصورة (هل قام المستخدم برفع صورة الروشتة؟)
  bool _hasPrescriptionImage = false; 

  int selectedOption = 0; // 0: داخل المدينة، 1: خارج المدينة
  int get price => selectedOption == 0 ? 25 : 40;

  // ألوان المشروع الموحدة عالية التباين
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);

  @override
  void dispose() {
    _medicineController.dispose();
    super.dispose();
  }

  void _submitOrder() {
    // الفحص الذكي: لو الفورم تمام (مكتوب داتا أو مرفوع صورة) هينتقل لصفحة الدفع
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentConfirmationScreen(
            totalAmount: price,
            method: "vodafone",
            serviceName: "طلبات الصيدلية",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "طلبات الصيدلية",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
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
                    "طلب علاج أو مستلزمات طبية",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: navyBlue),
                  ),
                ),
                
                // بوكس كتابة الأدوية مع الـ Validation الذكي
                TextFormField(
                  controller: _medicineController,
                  maxLines: 4,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: navyBlue, fontSize: 15),
                  validator: (value) {
                    // لو الحقل فاضي والمستخدم مرفعش كمان صورة روشتة، تطلع رسالة الخطأ
                    if ((value == null || value.trim().isEmpty) && !_hasPrescriptionImage) {
                      return "يرجى كتابة أسماء الأدوية أو رفع صورة الروشتة الطبية أولاً";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "اكتب أسماء الأدوية أو الطلبات هنا بالتفصيل...",
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

                // زرار رفع الروشتة بتصميم Minimalist متناسق مع المشروع
                InkWell(
                  onTap: () {
                    // محاكاة رفع الصورة لتجربة الـ Validation
                    setState(() {
                      _hasPrescriptionImage = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: primaryGreen,
                        content: Text("تم التقاط صورة الروشتة بنجاح", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.right),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: _hasPrescriptionImage ? const Color(0xFFDCFCE7) : Colors.white, // يقلب أخضر خفيف لو رفع صورة
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _hasPrescriptionImage ? primaryGreen : Colors.grey.shade300, 
                        width: 1.2
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _hasPrescriptionImage ? Icons.check_circle_rounded : Icons.add_a_photo_rounded, 
                          color: primaryGreen, 
                          size: 28
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _hasPrescriptionImage ? "تم حفظ الروشتة المرفقة" : "تصوير أو رفع صورة الروشتة", 
                          style: TextStyle(color: _hasPrescriptionImage ? Colors.green.shade900 : navyBlue, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
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

                // بوكس خيارات التوصيل بالفاصل الناعم والمريح للعين
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
                      // الفاصل الناعم الأنيق
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

                const SizedBox(height: 36),

                // زر تأكيد وحجز الأوردر
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