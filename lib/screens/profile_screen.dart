import 'package:flutter/material.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          'الملف الشخصي',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // قسم صورة الاسم والبيانات الأساسية
              CircleAvatar(
                radius: 50,
                backgroundColor: primaryGreen.withOpacity(0.1),
                child: const Icon(Icons.person, size: 55, color: primaryGreen),
              ),
              const SizedBox(height: 16),
              const Text(
                'أحمد محمد',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'ahmed@baddal.com',
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
              const SizedBox(height: 30),

              // خيارات الحساب
              _buildProfileOption(
                icon: Icons.edit_outlined,
                title: 'تعديل البيانات الشخصية',
                iconColor: primaryGreen,
                onTap: () {},
              ),
              _buildProfileOption(
                icon: Icons.location_on_outlined,
                title: 'العناوين المحفوظة (أجا)',
                iconColor: primaryGreen,
                onTap: () {},
              ),
              
              // خيار خاص بلوحة تحكم الأدمين (سنربطه بالصفحة التي صممتها لاحقاً)
              _buildProfileOption(
                icon: Icons.admin_panel_settings_outlined,
                title: 'لوحة تحكم الإدارة (Admin)',
                iconColor: navyBlue,
                onTap: () {
                  // هنا سنفتح صفحة الأدمين لاحقاً
                },
              ),
              
              _buildProfileOption(
                icon: Icons.share_outlined,
                title: 'شارك تطبيق بدال مع أصدقائك',
                iconColor: primaryGreen,
                onTap: () {},
              ),
              
              const SizedBox(height: 40),

              // زر تسجيل الخروج (يرجعك للبوابة ويقفل كل شيء خلفه)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // كود آمن يمسح الطابور ويرجعك للوج إن كأنك لسه فاتح التطبيق
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  label: const Text(
                    'تسجيل الخروج',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.redAccent),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent, width: 1.2),
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

  // ويدجت لبناء صفوف الخيارات بأسلوب مينيماليست بسيط
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
    );
  }
}