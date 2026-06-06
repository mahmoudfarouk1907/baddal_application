import 'package:flutter/material.dart';
import 'payment_confirmation_screen.dart';

class DeliveryPackageScreen extends StatefulWidget {
  const DeliveryPackageScreen({super.key});

  @override
  State<DeliveryPackageScreen> createState() => _DeliveryPackageScreenState();
}

class _DeliveryPackageScreenState extends State<DeliveryPackageScreen> {
  // الكنترولرز للتحكم في النصوص
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // مفتاح الفورم للفحص الذكي
  final _formKey = GlobalKey<FormState>(); 
  
  int selectedOption = 0; // 0: داخل المدينة، 1: خارج المدينة
  int get price => selectedOption == 0 ? 25 : 40;

  // الألوان الموحدة للمشروع (High Contrast)
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitOrder() {
    // التأكد من أن كل الحقول مليانة قبل الانتقال للدفع
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentConfirmationScreen(
            totalAmount: price,
            method: "vodafone",
            serviceName: "توصيل طرد",
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
          "توصيل طرد",
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
                // --- القسم الأول: خط السير ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    "خط سير الطرد",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: navyBlue),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300, width: 1.2),
                  ),
                  child: Column(
                    children: [
                      _buildTextField(
                        _fromController, 
                        "استلام الطرد من (العنوان بالتفصيل)", 
                        Icons.location_on_rounded, 
                        "يرجى تحديد مكان الاستلام"
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _toController, 
                        "تسليم الطرد في (العنوان بالتفصيل)", 
                        Icons.flag_rounded, 
                        "يرجى تحديد مكان التسليم"
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),

                // --- القسم الثاني: وصف الطرد ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    "بيانات ومحتويات الطرد",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: navyBlue),
                  ),
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 2,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: navyBlue, fontSize: 15),
                  validator: (value) => (value == null || value.trim().isEmpty) ? "يرجى وصف محتوى الطرد" : null,
                  decoration: InputDecoration(
                    hintText: "مثال: شنطة ملابس، أوراق مهمة، أمانة صيدلية...",
                    hintStyle: TextStyle(color: navyBlue.withValues(alpha: 0.4), fontSize: 14),
                    fillColor: Colors.white,
                    filled: true,
                    errorStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14), 
                      borderSide: BorderSide(color: Colors.grey.shade400)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14), 
                      borderSide: const BorderSide(color: primaryGreen, width: 2)
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14), 
                      borderSide: const BorderSide(color: Colors.red)
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // --- القسم الثالث: نطاق التوصيل ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text(
                    "نطاق التوصيل",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: navyBlue),
                  ),
                ),
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
                      // الفاصل الناعم (بدل الخط الأسود)
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

                // --- زر التأكيد النهائي ---
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

  // ودجت مساعد لبناء حقول العناوين بتصميم موحد
  Widget _buildTextField(TextEditingController controller, String label, IconData icon, String error) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontWeight: FontWeight.w600, color: navyBlue, fontSize: 15),
      validator: (value) => (value == null || value.trim().isEmpty) ? error : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 13),
        prefixIcon: Icon(icon, color: primaryGreen, size: 22),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        errorStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: BorderSide(color: Colors.grey.shade300)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: const BorderSide(color: primaryGreen, width: 2)
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: const BorderSide(color: Colors.red)
        ),
      ),
    );
  }
}