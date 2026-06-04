import 'package:flutter/material.dart';
import 'payment_confirmation_screen.dart';

class CaptainRideScreen extends StatefulWidget {
  const CaptainRideScreen({super.key});

  @override
  State<CaptainRideScreen> createState() => _CaptainRideScreenState();
}

class _CaptainRideScreenState extends State<CaptainRideScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // مفتاح التحكم في التحقق من المدخلات
  
  int selectedOption = 0; 
  int get price => selectedOption == 0 ? 25 : 40;

  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _submitOrder() {
    // لو كل الحقول مليانة وتمام، هيعدي ويدخل لصفحة الدفع
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentConfirmationScreen(
            totalAmount: price,
            method: "vodafone",
            serviceName: "طلب كابتن",
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
        title: const Text("طلب كابتن مشاوير", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
            key: _formKey, // ربط الـ Form بالمفتاح
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // قسم مدخلات العناوين
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300, width: 1.2),
                  ),
                  child: Column(
                    children: [
                      _buildTextFormField(_fromController, "مكان الاستلام", Icons.location_on_rounded, "يرجى تحديد مكان الاستلام"),
                      const SizedBox(height: 16),
                      _buildTextFormField(_toController, "مكان التوصيل", Icons.flag_rounded, "يرجى تحديد مكان التوصيل"),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Text("نطاق التوصيل", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: navyBlue)),
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
                        title: const Text("داخل المدينة (25 جنيه)", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue)),
                        value: 0,
                        groupValue: selectedOption,
                        onChanged: (val) => setState(() => selectedOption = val!),
                      ),
                      Divider(color: Colors.grey.shade200, height: 1),
                      RadioListTile<int>(
                        activeColor: primaryGreen,
                        title: const Text("خارج المدينة (40 جنيه)", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue)),
                        value: 1,
                        groupValue: selectedOption,
                        onChanged: (val) => setState(() => selectedOption = val!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _submitOrder, // استدعاء دالة التأكيد الذكية
                    child: Text("تأكيد الطلب ($price ج.م)", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // الودجت المعدل لدعم التنبيهات الداخلية عالية التباين
  Widget _buildTextFormField(TextEditingController controller, String label, IconData icon, String errorText) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontWeight: FontWeight.w600, color: navyBlue),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return errorText; // النص اللي هيظهر تحت البوكس علطول لو فاضي
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: navyBlue, fontWeight: FontWeight.bold),
        prefixIcon: Icon(icon, color: primaryGreen),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        errorStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red), // خط عريض واضح للخطأ
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 1.2), // حدود حمراء عند الخطأ
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
      ),
    );
  }
}