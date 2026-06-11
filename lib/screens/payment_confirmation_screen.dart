import 'package:flutter/material.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final int totalAmount;
  final String method;
  final String serviceName;

  const PaymentConfirmationScreen({
    super.key,
    required this.totalAmount,
    required this.method,
    required this.serviceName,
  });

  @override
  State<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  // استخدام نفس اللون الداكن لضمان أعلى تباين ووضوح
  static const Color darkText = Color(0xFF0F172A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("تأكيد الطلب", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // كارت الحساب الكلي واسم الخدمة
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.serviceName, 
                      style: const TextStyle(fontSize: 18, color: darkText, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "إجمالي حساب الرحلة",
                      style: TextStyle(fontSize: 14, color: darkText, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.totalAmount} جنيه",
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // عنوان تفاصيل الطلب والدفع
              const Text(
                "تفاصيل الطلب والدفع عند الاستلام:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: darkText),
              ),
              const SizedBox(height: 16),

              // 💡 الكارت الجديد البديل لفودافون كاش: بيعرض تفاصيل المحطات والدفع كاش
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    // تفاصيل نوع الخدمة
                    _buildOrderRow(Icons.local_shipping_rounded, "نوع الخدمة:", widget.serviceName),
                    const Divider(height: 24),
                    
                    // تفاصيل طريقة الدفع
                    _buildOrderRow(Icons.money_rounded, "طريقة الدفع:", "نقداً عند الاستلام (Cash)"),
                    const Divider(height: 24),

                    // إجمالي الحساب الكلي
                    _buildOrderRow(Icons.payments_rounded, "الحساب الكلي المطلوب:", "${widget.totalAmount} جنيه", isTotal: true),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),

              // 💡 الملحوظة الهامة جداً لليوزر (حساب الخدمة فقط)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Colors.amber, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "ملحوظة: هذا المبلغ يشمل تكلفة تقديم الخدمة ومصاريف الرحلة فقط لا غير.",
                        style: TextStyle(color: darkText, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // زرار إرسال الطلب النهائي
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
                        content: const Text(
                          "تم استلام طلبك بنجاح!\nالكابتن في طريقه إليك الآن وسيتم الدفع كاش.", 
                          textAlign: TextAlign.center, 
                          style: TextStyle(fontWeight: FontWeight.bold, color: darkText),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), 
                            child: const Text("العودة للرئيسية", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          )
                        ],
                      ),
                    );
                  },
                  child: const Text("تأكيد وإرسال الطلب كاش", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة مخصصة لبناء صفوف تفاصيل الأوردر بشكل متناسق
  Widget _buildOrderRow(IconData icon, String label, String value, {bool isTotal = false}) {
    return Row(
      children: [
        Icon(icon, color: isTotal ? Colors.green.shade700 : Colors.grey.shade600, size: 24),
        const SizedBox(width: 12),
        Text(
          label, 
          style: TextStyle(
            fontSize: 14, 
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500, 
            color: darkText
          ),
        ),
        const Spacer(),
        Text(
          value, 
          style: TextStyle(
            fontSize: isTotal ? 18 : 15, 
            fontWeight: FontWeight.bold, 
            color: isTotal ? Colors.green.shade800 : darkText
          ),
        ),
      ],
    );
  }
}