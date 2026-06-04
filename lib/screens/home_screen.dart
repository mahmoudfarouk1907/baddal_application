import 'package:flutter/material.dart';
// الأبمورتات القديمة والجديدة متظبطة
import 'notifications_screen.dart';
import 'captain_ride_screen.dart';
import 'delivery_package_screen.dart';
import 'supermarket_screen.dart';
import 'pharmacy_screen.dart';
import 'multi_order_screen.dart'; // إمبورت شاشة المشوار الحر الجديدة

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. الجزء العلوي (Header)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("مرحباً بك في", style: TextStyle(fontSize: 16, color: Colors.grey)),
                        Text(
                          "بدّال لخدمات التوصيل",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: IconButton(
                        icon: const Icon(Icons.notifications_active_outlined, color: Colors.green),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 2. كارت الشعار الإعلاني (Banner)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade600, Colors.green.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "مش فاضي؟ بدّال بدالك",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "اطلب كابتن يخلص لك كل مشاويرك ويوصل طلباتك في أسرع وقت وأمان تام.",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 3. عنوان قسم الخدمات
                const Text(
                  "اختر الخدمة التي تحتاجها:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 16),

                // 4. شبكة الخدمات (Services Grid) المتعدلة
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildServiceCard(
                      context,
                      title: "طلب كابتن مشاوير",
                      subtitle: "يقضيلك مشوارك الخاص",
                      icon: Icons.directions_bike,
                      color: Colors.orange,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CaptainRideScreen()));
                      },
                    ),
                    // كارت الخدمة الجديدة اللى ضيفناها
                    _buildServiceCard(
                      context,
                      title: "مشوار حر (متعدد)",
                      subtitle: "طلبات من كذا مكان في رحلة",
                      icon: Icons.add_location_alt_rounded,
                      color: Colors.indigo, // لون كحلي مميز للـ VIP متعدد النقاط
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const MultiOrderScreen()));
                      },
                    ),
                    _buildServiceCard(
                      context,
                      title: "توصيل طرد أو أمانة",
                      subtitle: "إرسال واستلام أي حاجة",
                      icon: Icons.local_shipping,
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const DeliveryPackageScreen()));
                      },
                    ),
                    _buildServiceCard(
                      context,
                      title: "طلبات سوبرماركت",
                      subtitle: "نجيبلك طلبات البيت",
                      icon: Icons.shopping_basket,
                      color: Colors.purple,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SupermarketScreen()));
                      },
                    ),
                    _buildServiceCard(
                      context,
                      title: "طلبات الصيدلية",
                      subtitle: "علاجاتك لحد باب بيتك",
                      icon: Icons.local_pharmacy,
                      color: Colors.red,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PharmacyScreen()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}