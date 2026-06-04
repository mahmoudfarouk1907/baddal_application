import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("التنبيهات وحالة الطلبات", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("الطلبات الحالية", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          
          _buildOrderTrackerCard(
            title: "طلب مشاوير #4402",
            status: "تم تحضير الطلب - الكابتن في الطريق إليك",
            time: "منذ دقيقتين",
            icon: Icons.delivery_dining,
            color: Colors.orange,
            isActive: true,
          ),
          
          const SizedBox(height: 24),
          const Text("الطلبات السابقة والإشعارات", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 10),
          
          _buildOrderTrackerCard(
            title: "طلبات صيدلية #3910",
            status: "تم التوصيل بنجاح",
            time: "بالأمس",
            icon: Icons.check_circle,
            color: Colors.green,
            isActive: false,
          ),
          _buildOrderTrackerCard(
            title: "توصيل طرد #3882",
            status: "طلب ملغي من قِبل المستخدم",
            time: "3 يونيو 2026",
            icon: Icons.cancel,
            color: Colors.red,
            isActive: false,
          ),
        ],
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
    return Card(
      color: Colors.white,
      elevation: isActive ? 2 : 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isActive ? color.withOpacity(0.5) : Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(status, style: TextStyle(color: isActive ? Colors.black87 : Colors.grey, fontSize: 13)),
            const SizedBox(height: 4),
            Text(time, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}