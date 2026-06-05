import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; 
import 'login_screen.dart';
import 'edit_profile_screen.dart';
import 'saved_addresses_screen.dart';
// 1. استدعاء صفحة الأدمن الجديدة هنا
import 'admin_panel_screen.dart'; 
import 'main_layout.dart'; // استدعاء شاشة الـ ليرجع لها بالـ Navbar

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color navyBlue = Color(0xFF0F172A);

  // 2. جعلنا الإيميل الحالي هو نفسه إيميل الأدمن عشان الزرار يظهرلك فوراً وتجرب براحتك
  static const String adminEmail = "ahmed@baddal.com"; 
  static const String currentUserEmail = "ahmed@baddal.com"; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'الملف الشخصي',
          style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navyBlue),
          onPressed: () {
            // التعديل السحري: لو فيه شاشة وراه هيرجع، لو مفيش هيفجر الـ MainLayout بالـ Navbar
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainLayout()),
              );
            }
          },
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // --- قسم الصورة الشخصية ---
              Stack(
                children: [
                  CircleAvatar(
                    radius: 54,
                    backgroundColor: primaryGreen.withOpacity(0.1),
                    child: const Icon(Icons.person, size: 60, color: primaryGreen),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'أحمد محمد',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: navyBlue),
              ),
              const SizedBox(height: 4),
              const Text(
                currentUserEmail,
                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),

              // --- كارد الخيارات ---
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200, width: 1.2),
                ),
                child: Column(
                  children: [
                    _buildProfileOption(
                      icon: Icons.edit_outlined,
                      title: 'تعديل البيانات الشخصية',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                      },
                    ),
                    Divider(color: Colors.grey.shade100, height: 1, thickness: 1.2),
                    _buildProfileOption(
                      icon: Icons.location_on_outlined,
                      title: 'العناوين المحفوظة (أجا)',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SavedAddressesScreen()));
                      },
                    ),
                    Divider(color: Colors.grey.shade100, height: 1, thickness: 1.2),
                    _buildProfileOption(
                      icon: Icons.share_outlined,
                      title: 'شارك تطبيق بدال مع أصدقائك',
                      onTap: () {
                        Share.share('حمل تطبيق بدال الآن واطلب كل مشاويرك: https://baddal.com/download');
                      },
                    ),
                  ],
                ),
              ),

              // 3. هنا بيحصل الفحص السحري: لو الحساب المفتوح هو حساب الأدمن، بيظهر له الخيار ده تلقائياً
              if (currentUserEmail == adminEmail) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: navyBlue.withOpacity(0.05),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      // الانتقال المباشر للوحة تحكم المسؤول
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => const AdminPanelScreen())
                      );
                    },
                    icon: const Icon(Icons.admin_panel_settings_rounded, color: navyBlue),
                    label: const Text(
                      "الدخول كمسؤول النظام", 
                      style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 32),

              // --- زر تسجيل الخروج ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, color: Colors.red),
                  label: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red.shade200, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: primaryGreen.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: primaryGreen, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: navyBlue),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
    );
  }
}