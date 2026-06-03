import 'package:flutter/material.dart';
import 'doctor_screen.dart';
import 'delivery_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // التحقق من وضع النظام (داكن أو فاتح) لتغيير الخلفيات تلقائياً
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // ألوان الهوية المعتمدة لـ "بدال"
    const primaryGreen = Color(0xFF22C55E); // الأخضر العشبي
    const navyBlue = Color(0xFF0F172A);    // الكحلي الداكن

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.notifications_none, color: isDarkMode ? Colors.white : navyBlue),
          onPressed: () {},
        ),
        actions: [
          Row(
            children: [
              const Text(
                'بدال',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              // التعديل: جعل زر البروفايل يفتح شاشة الـ ProfileScreen عند الضغط عليه
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(18),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: primaryGreen.withOpacity(0.2),
                  child: const Icon(Icons.person, color: primaryGreen, size: 20),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // التطبيق باللغة العربية
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // قسم الترحيب
              const Text(
                'أهلاً بك يا محمود 👋',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'تطبيق بدال لخدمات التوصيل والحجز داخل أجا',
                style: TextStyle(
                  fontSize: 15,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),

              // كارت طلب خدمة توصيل (الأخضر العشبي)
              _buildServiceCard(
                title: 'طلب خدمة توصيل',
                subtitle: 'مندوب خاص لتوصيل طلباتك داخل أجا بـ 25 جنيه',
                icon: Icons.local_shipping_rounded,
                backgroundColor: primaryGreen,
                textColor: Colors.white,
                iconColor: Colors.white,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DeliveryScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),

              // كارت حجز موعد طبيب
              _buildServiceCard(
                title: 'حجز موعد طبيب',
                subtitle: 'احجز ميعادك بسهولة (الأسعار من 50 لـ 100 جنيه)',
                icon: Icons.local_hospital_rounded,
                backgroundColor: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
                textColor: isDarkMode ? Colors.white : navyBlue,
                iconColor: primaryGreen,
                hasBorder: !isDarkMode,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DoctorScreen()),
                  );
                },
              ),
              const SizedBox(height: 35),

              // قسم النشاط الأخير
              const Text(
                'النشاط الأخير',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // عملية تجريبية سابقة بسعر أجا الثابت
              _buildActivityItem(
                title: 'طلب توصيل من السوبرماركت',
                status: 'تم التوصيل بنجاح',
                price: '25 ج.م',
                icon: Icons.check_circle_rounded,
                iconColor: primaryGreen,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ويدجت لبناء الكروت الكبيرة
  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required Color iconColor,
    bool hasBorder = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: hasBorder ? Border.all(color: Colors.grey[200]!) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 45, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: textColor.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: textColor.withOpacity(0.6)),
          ],
        ),
      ),
    );
  }

  // ويدجت لبناء عناصر قائمة النشاط الأخير
  Widget _buildActivityItem({
    required String title,
    required String status,
    required String price,
    required IconData icon,
    required Color iconColor,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isDarkMode ? null : Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(status, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF22C55E)),
          ),
        ],
      ),
    );
  }
}