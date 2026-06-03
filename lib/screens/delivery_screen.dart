import 'package:flutter/material.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryGreen = Color(0xFF22C55E); // الأخضر العشبي
    const navyBlue = Color(0xFF0F172A);    // الكحلي

    // محاكاة لحالة الطلب الحالية (يمكن تغيير الرقم من 0 لـ 3 لتجربة حركة النقط)
    int currentStep = 1; 

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'تتبع طلبك',
          style: TextStyle(color: isDarkMode ? Colors.white : navyBlue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDarkMode ? Colors.white : navyBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // كارت ملخص السعر الثابت لأجا (تم تصحيحه هنا)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: primaryGreen.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'تكلفة التوصيل (داخل أجا):',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '25 ج.م',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryGreen),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),

              const Text(
                'حالة الشحنة الآن:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              // نظام التتبع المكون من 4 نقاط
              Expanded(
                child: ListView(
                  children: [
                    _buildTrackingStep(
                      title: 'تم قبول الطلب',
                      subtitle: 'تم تأكيد طلبك من قبل النظام وجاري التعيين.',
                      icon: Icons.assignment_turned_in_rounded,
                      isCompleted: currentStep >= 0,
                      isLast: false,
                      primaryGreen: primaryGreen,
                    ),
                    _buildTrackingStep(
                      title: 'جاري تجهيز الطلب (10 دقائق)',
                      subtitle: 'المندوب يقوم بتجميع أشياءك الآن.',
                      icon: Icons.timer_rounded,
                      isCompleted: currentStep >= 1,
                      isLast: false,
                      primaryGreen: primaryGreen,
                    ),
                    _buildTrackingStep(
                      title: 'الكابتن في الطريق إليك',
                      subtitle: 'طلبك يتحرك الآن مع المندوب الخاص بك.',
                      icon: Icons.delivery_dining_rounded,
                      isCompleted: currentStep >= 2,
                      isLast: false,
                      primaryGreen: primaryGreen,
                    ),
                    _buildTrackingStep(
                      title: 'تم التوصيل',
                      subtitle: 'نتمنى أن نكون قد أسعدناك بخدمتنا!',
                      icon: Icons.check_circle_rounded,
                      isCompleted: currentStep >= 3,
                      isLast: true,
                      primaryGreen: primaryGreen,
                    ),
                  ],
                ),
              ),

              // زر الدعم الفني السريع عبر واتساب لتقليل التكلفة
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // هنا سيتم وضع رابط فتح الواتساب لاحقاً
                  },
                  icon: const Icon(Icons.chat_rounded, color: Colors.white),
                  label: const Text('تواصل مع الكابتن (واتساب)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF075E54), // لون الواتساب الرسمي
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت رسم خط التتبع والنقاط
  Widget _buildTrackingStep({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isCompleted,
    required bool isLast,
    required Color primaryGreen,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isCompleted ? primaryGreen : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            if (!isLast)
              Container(
                width: 3,
                height: 55,
                color: isCompleted ? primaryGreen : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? primaryGreen : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }
}