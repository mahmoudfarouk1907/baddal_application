// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'notifications_screen.dart';
import 'captain_ride_screen.dart';
import 'delivery_package_screen.dart';
import 'supermarket_screen.dart';
import 'pharmacy_screen.dart';
import 'multi_order_screen.dart';
import 'active_order_tracking_screen.dart'; 
import 'support_complaints_screen.dart';     
import 'admin_panel_screen.dart';          

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E); 

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final bool _hasActiveOrder = true;

  String _userName = "محمود فاروق";
  String _userEmail = "mahmoudfarouk@gmail.com";
  String _userRole = "user"; // 🔑 متغير جديد لحفظ صلاحية المستخدم الحالي

  @override
  void initState() {
    super.initState();
    _loadUserData(); 

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  // 🔄 الفانكشن المحدثة لجلب الاسم والإيميل والـ Role معاً
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? "محمود فاروق";
      _userEmail = prefs.getString('user_email') ?? "mahmoudfarouk@gmail.com";
      _userRole = prefs.getString('user_role') ?? "user"; // جلب الصلاحية (main_admin, cash_admin, user)
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Builder(
                            builder: (context) => IconButton(
                              icon: const Icon(Icons.menu_rounded, color: navyBlue, size: 30),
                              onPressed: () => Scaffold.of(context).openDrawer(),
                            ),
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("مرحباً بك في", style: TextStyle(fontSize: 14, color: Colors.grey)),
                              Text(
                                "بدّال لخدمات التوصيل",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryGreen),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            child: IconButton(
                              icon: const Icon(Icons.notifications_active_outlined, color: primaryGreen),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()));
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryGreen, Colors.green.shade400],
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
                            SizedBox(height: 8),
                            Text(
                              "اطلب كابتن يخلص لك كل مشاويرك ويوصل طلباتك في أسرع وقت وأمان تام.",
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      const Text(
                        "اختر الخدمة التي تحتاجها:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),

                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                        children: [
                          _buildServiceCard(context, title: "طلب كابتن مشاوير", subtitle: "يقضيلك مشوارك الخاص", icon: Icons.directions_bike, color: Colors.orange, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CaptainRideScreen()))),
                          _buildServiceCard(context, title: "مشوار حر (متعدد)", subtitle: "طلبات من كذا مكان في رحلة", icon: Icons.add_location_alt_rounded, color: Colors.indigo, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MultiOrderScreen()))),
                          _buildServiceCard(context, title: "توصيل طرد أو أمانة", subtitle: "إرسال واستلام أي حاجة", icon: Icons.local_shipping, color: Colors.blue, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DeliveryPackageScreen()))),
                          _buildServiceCard(context, title: "طلبات سوبرماركت", subtitle: "نجيبلك طلبات البيت", icon: Icons.shopping_basket, color: Colors.purple, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupermarketScreen()))),
                          _buildServiceCard(context, title: "طلبات الصيدلية", subtitle: "علاجاتك لحد باب بيتك", icon: Icons.local_pharmacy, color: Colors.red, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PharmacyScreen()))),
                        ],
                      ),
                      const SizedBox(height: 120), 
                    ],
                  ),
                ),
              ),
            ),

            if (_hasActiveOrder)
              Positioned(
                bottom: 80, 
                right: 24,  
                child: _buildPulsingFAB(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPulsingFAB() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 65 * _pulseAnimation.value,
              height: 65 * _pulseAnimation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryGreen.withValues(alpha: 0.4 * (1.8 - _pulseAnimation.value)),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ActiveOrderTrackingScreen()));
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryGreen,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: const Icon(Icons.location_searching_rounded, color: Colors.white, size: 28),
              ),
            ),
          ],
        );
      },
    );
  }

  // 🚪 بناء الـ Drawer مع إخفاء زرار الأدمن تماماً عن اليوزرز العاديين
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: primaryGreen), 
              accountName: Text(_userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)), 
              accountEmail: Text(_userEmail, style: const TextStyle(color: Colors.white60)), 
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: primaryGreen, size: 45),
              ),
            ),
            _buildDrawerItem(icon: Icons.location_searching_rounded, title: "تتبع طلبي الحالي", onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const ActiveOrderTrackingScreen())); }),
            _buildDrawerItem(icon: Icons.headset_mic_rounded, title: "الدعم الفني والشكاوى", onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportComplaintsScreen())); }),
            
            // 🔒 تعديل أمني: الزرار الأحمر والفاصل لن يظهرا إلا إذا كان الحساب "main_admin" فقط
            if (_userRole == 'main_admin') ...[
              const Divider(color: Colors.grey, thickness: 0.5),
              _buildDrawerItem(
                icon: Icons.admin_panel_settings_rounded, 
                title: "لوحة تحكم المسؤول", 
                iconColor: Colors.red.shade600, 
                textColor: Colors.red.shade600, 
                onTap: () { 
                  Navigator.pop(context); 
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPanelScreen())); 
                },
              ),
            ],
            
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("إصدار التطبيق 1.0.0", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title, required VoidCallback onTap, Color iconColor = primaryGreen, Color textColor = navyBlue}) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: 15)),
      onTap: onTap,
    );
  }

  Widget _buildServiceCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 6, offset: const Offset(0, 3))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, size: 30, color: color)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ],
        ),
      ),
    );
  }
}