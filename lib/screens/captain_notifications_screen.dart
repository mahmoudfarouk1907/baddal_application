// lib/screens/captain_notifications_screen.dart

import 'package:flutter/material.dart';

class CaptainNotificationsScreen extends StatelessWidget {
  const CaptainNotificationsScreen({super.key});

  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    // قائمة تجريبية لإشعارات الكابتن وسجل طلباته
    final List<Map<String, String>> notifications = [
      {
        "title": "تم إيداع أرباح أوردر #B991",
        "body": "عاش يا كابتن! تم تسليم الطلب بنجاح وإضافة 20 جنيه إلى محفظتك المالية.",
        "time": "منذ 5 دقائق",
        "type": "order"
      },
      {
        "title": "تنبيه هام من إدارة بدال ⚠️",
        "body": "يرجى العلم أنه يوجد تحديث جديد للأبليكيشن الليلة، تأكد من تحديث التطبيق لتجنب انقطاع الخدمة.",
        "time": "منذ ساعتين",
        "type": "admin"
      },
      {
        "title": "تم قبول طلب السحب الخاص بك 💸",
        "body": "تمت الموافقة على طلب سحب 150 جنيه وتم تحويلها إلى محفظتك الإلكترونية بنجاح.",
        "time": "أمس",
        "type": "wallet"
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("تنبيهات وإشعارات الكابتن", style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navyBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: notifications.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text("لا توجد إشعارات حالياً", style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final item = notifications[index];
                  IconData iconData = Icons.notifications_rounded;
                  Color iconColor = primaryGreen;

                  if (item['type'] == 'admin') {
                    iconData = Icons.campaign_rounded;
                    iconColor = Colors.amber.shade700;
                  } else if (item['type'] == 'wallet') {
                    iconData = Icons.account_balance_wallet_rounded;
                    iconColor = Colors.blue;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: iconColor.withValues(alpha: 0.1),
                          child: Icon(iconData, color: iconColor, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['title']!, style: const TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(item['body']!, style: const TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.4)),
                              const SizedBox(height: 8),
                              Text(item['time']!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}