import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final String walletNumber = "01012345678";
  final String instaPayId = "baddal@instapay";
  
  // استخدام نفس اللون الداكن لضمان أعلى تباين ووضوح
  static const Color darkText = Color(0xFF0F172A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("تأكيد الدفع", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
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
                    // تعديل: تحويل اسم الخدمة للون داكن وخط عريض بدلاً من الرمادي الشفاف
                    Text(
                      widget.serviceName, 
                      style: const TextStyle(fontSize: 16, color: darkText, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${widget.totalAmount} جنيه",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "قم بالتحويل إلى البيانات التالية:", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: darkText),
              ),
              const SizedBox(height: 16),
              _buildTransferDetails(
                title: widget.method == "vodafone" ? "رقم فودافون كاش" : "عنوان InstaPay",
                value: widget.method == "vodafone" ? walletNumber : instaPayId,
                icon: widget.method == "vodafone" ? Icons.phone_android : Icons.account_balance_wallet,
              ),
              const SizedBox(height: 40),
              const Text(
                "ارفع صورة إيصال التحويل للتأكيد", 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: darkText),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("جاري فتح الاستوديو..."))),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.green.shade700),
                      const SizedBox(height: 8),
                      const Text(
                        "اضغط هنا لرفع سكرين شوت التحويل",
                        style: TextStyle(fontWeight: FontWeight.w600, color: darkText, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
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
                        title: const Icon(Icons.check_circle, color: Colors.green, size: 60),
                        content: const Text("تم استلام طلبك بنجاح!", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), 
                            child: const Text("العودة للرئيسية", style: TextStyle(fontWeight: FontWeight.bold)),
                          )
                        ],
                      ),
                    );
                  },
                  child: const Text("إرسال الطلب الآن", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransferDetails({required String title, required String value, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)]),
      child: Row(
        children: [
          Icon(icon, color: Colors.green.shade700, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, 
            children: [
              // تعديل: تغميق لون العنوان الفرعي لزيادة حدة القراءة لضعاف النظر
              Text(title, style: TextStyle(color: darkText.withValues(alpha: 0.7), fontSize: 13, fontWeight: FontWeight.w500)), 
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: darkText)),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.copy, size: 22, color: darkText), 
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم نسخ البيانات بنجاح")));
            },
          ),
        ],
      ),
    );
  }
}