// lib/screens/captain_orders_screen.dart

import 'package:flutter/material.dart';
import 'captain_active_order_screen.dart';
import 'captain_wallet_screen.dart';
import 'captain_profile_screen.dart'; 
import 'captain_notifications_screen.dart';

// 👇 الكلاس المجمع الرئيسي اللي الـ main.dart قالبة الدنيا عليه
class CaptainMainLayout extends StatefulWidget {
  const CaptainMainLayout({super.key});

  @override
  State<CaptainMainLayout> createState() => _CaptainMainLayoutState();
}

class _CaptainMainLayoutState extends State<CaptainMainLayout> {
  int _selectedIndex = 0;
  static const Color primaryGreen = Color(0xFF22C55E);

  final List<Widget> _screens = [
    const AvailableOrdersScreen(), 
    const CaptainWalletScreen(),   
    const CaptainProfileScreen(),  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Directionality(
        textDirection: TextDirection.rtl,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: primaryGreen,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.moped_rounded),
              label: 'الطلبات المتاحة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet_rounded, color: primaryGreen),
              label: 'محفظتي',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded, color: primaryGreen),
              label: 'الحساب',
            ),
          ],
        ),
      ),
    );
  }
}

// --- شاشة عرض كروت الطلبات المتاحة ---
class AvailableOrdersScreen extends StatefulWidget {
  const AvailableOrdersScreen({super.key});

  @override
  State<AvailableOrdersScreen> createState() => _AvailableOrdersScreenState();
}

class _AvailableOrdersScreenState extends State<AvailableOrdersScreen> {
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color backgroundColor = Color(0xFFF8FAFC);

  final List<Map<String, dynamic>> _availableOrders = [
    {
      "orderId": "#B991",
      "pickup": "صيدلية د. أحمد - شارع الجمهورية",
      "dropoff": "أجا - بجوار مسجد النور",
      "price": 25.0,
      "type": "normal", 
    },
    {
      "orderId": "#B992",
      "pickup": "سوبر ماركت الأمانة - وسط البلد",
      "dropoff": "أجا - حي النزهة، عمارة 4",
      "price": 30.0,
      "type": "normal", 
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "الطلبات المتاحة - كابتن بدال",
          style: TextStyle(color: navyBlue, fontWeight: FontWeight.w900, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: navyBlue, size: 26),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CaptainNotificationsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            const Text("متصل", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        leadingWidth: 80,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _availableOrders.length,
          itemBuilder: (context, index) {
            final order = _availableOrders[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100, width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order["orderId"], style: const TextStyle(color: navyBlue, fontWeight: FontWeight.bold)),
                      Text("${order["price"].toStringAsFixed(0)} جنيه", style: const TextStyle(color: primaryGreen, fontWeight: FontWeight.w900, fontSize: 18)),
                    ],
                  ),
                  const Divider(height: 24),
                  Text("من: ${order["pickup"]}", style: const TextStyle(color: navyBlue, fontSize: 14)),
                  const SizedBox(height: 8),
                  Text("إلى: ${order["dropoff"]}", style: const TextStyle(color: navyBlue, fontSize: 14)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("تم قبول الطلب ${order["orderId"]} بنجاح!"), backgroundColor: primaryGreen),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CaptainActiveOrderScreen(
                              orderId: order["orderId"],
                              orderType: order["type"],
                              orderPrice: order["price"], 
                            ),
                          ),
                        );
                      },
                      child: const Text("قبول الطلب وبدء المشوار 🚀", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}