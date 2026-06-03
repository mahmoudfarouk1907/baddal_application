import 'package:flutter/material.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    const primaryGreen = Color(0xFF22C55E); // الأخضر العشبي
    const navyBlue = Color(0xFF0F172A);    // الكحلي

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'حجز موعد طبيب',
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // نص توضيحي للعميل
              Text(
                'العيادات المتاحة في أجا الآن:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : navyBlue),
              ),
              const SizedBox(height: 15),

              // قائمة الأطباء
              Expanded(
                child: ListView(
                  children: [
                    _buildDoctorCard(
                      name: 'د. أحمد السعيد',
                      specialty: 'استشاري طب الأطفال وحديثي الولادة',
                      waitingTime: 'انتظار سريع (خلال ساعة)',
                      price: '100 ج.م',
                      isDarkMode: isDarkMode,
                      primaryGreen: primaryGreen,
                    ),
                    const SizedBox(height: 16),
                    _buildDoctorCard(
                      name: 'د. محمد متولي',
                      specialty: 'أخصائي أمراض الباطنة والقلب',
                      waitingTime: 'انتظار عادي (من ساعتين لـ 3 ساعات)',
                      price: '50 ج.م',
                      isDarkMode: isDarkMode,
                      primaryGreen: primaryGreen,
                    ),
                    const SizedBox(height: 16),
                    _buildDoctorCard(
                      name: 'د. سارة المنشاوي',
                      specialty: 'أخصائية طب وجراحة العيون',
                      waitingTime: 'انتظار متوسط (خلال ساعتين)',
                      price: '75 ج.م',
                      isDarkMode: isDarkMode,
                      primaryGreen: primaryGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت بناء كارت كل طبيب
  Widget _buildDoctorCard({
    required String name,
    required String specialty,
    required String waitingTime,
    required String price,
    required bool isDarkMode,
    required Color primaryGreen,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDarkMode ? null : Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: primaryGreen.withOpacity(0.1),
                child: Icon(Icons.medical_services_rounded, color: primaryGreen, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(specialty, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 0.5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(waitingTime, style: TextStyle(fontSize: 12, color: Colors.amber[800], fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text('سعر الكشف المتوقع', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // رابط واتساب لتأكيد الحجز مع إدارة بدال لاحقاً
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text(
                  'احجز بـ $price',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}