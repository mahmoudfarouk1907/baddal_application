import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  // تعريف ألوان ثابتة للتباين العالي
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // خلفية أنظف
      appBar: AppBar(
        title: const Text(
          "التنبيهات وحالة الطلبات",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // لضمان اتجاه اللغة العربية
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              "الطلبات الحالية",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: navyBlue, // لون داكن صريح
              ),
            ),
            const SizedBox(height: 12),
            
            _buildOrderTrackerCard(
              title: "طلب مشاوير #4402",
              status: "تم تحضير الطلب - الكابتن في الطريق إليك",
              time: "منذ دقيقتين",
              icon: Icons.delivery_dining,
              color: Colors.orange.shade800, // درجة أغمق للوضوح
              isActive: true,
            ),
            
            const SizedBox(height: 32), // مساحة أكبر للفصل بين الأقسام
            
            const Text(
              "الطلبات السابقة والإشعارات",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: navyBlue, // لون داكن بدل الرمادي الباهت
              ),
            ),
            const SizedBox(height: 12),
            
            _buildOrderTrackerCard(
              title: "طلبات صيدلية #3910",
              status: "تم التوصيل بنجاح",
              time: "بالأمس",
              icon: Icons.check_circle,
              color: Colors.green.shade700,
              isActive: false,
            ),
            _buildOrderTrackerCard(
              title: "توصيل طرد #3882",
              status: "طلب ملغي من قِبل المستخدم",
              time: "3 يونيو 2026",
              icon: Icons.cancel,
              color: Colors.red.shade700,
              isActive: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTrackerCard({
    required String title,
    required String status,
    required String time,
    required IconData icon,
    required Color color,
    required bool isActive,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? color : Colors.grey.shade300,
          width: isActive ? 2 : 1, // خط أسمك للطلب النشط
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: navyBlue,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              status,
              style: TextStyle(
                color: isActive ? Colors.black : navyBlue.withValues(alpha: 0.6),
                fontSize: 14,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}