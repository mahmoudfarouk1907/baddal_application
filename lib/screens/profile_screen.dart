// lib/screens/profile_screen.dart

import 'dart:convert'; // 💡 استدعاء مكتبة الـ JSON لفك وتحليل بيانات التقييمات
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; // استدعاء مكتبة الحفظ
import 'login_screen.dart';
import 'edit_profile_screen.dart';
import 'saved_addresses_screen.dart';
import 'admin_panel_screen.dart'; 
import 'main_layout.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color navyBlue = Color(0xFF0F172A);

  // 👑 تم التعديل للإيميل المعتمد والمنظف في صفحة اللوج إن لمنع التداخل
  static const String adminEmail = "ad@g.com"; 

  // المتغيرات تبدأ فارغة تماماً لضمان عدم عرض أي داتا وهمية قبل القراءة من الكاش
  String _userName = "";
  String _userEmail = "";
  String _userPhone = "";

  // 💡 متغيرات التقييم الكلي الافتراضية للكابتن
  double _captainAverageRating = 4.9;
  int _captainTotalRatings = 120;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // قراءة البيانات من كاش الجهاز فور فتح الصفحة
  }

  // 💡 الفانكشن هنا بقت تفحص إيميل الكابتن وتحسب التقييم الإجمالي لايف من نفس الـ Pool
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // قراءة البيانات الفعلية للمستخدم الحالي بدون وضع قيم افتراضية فاضحة لأي مستخدم آخر
    String savedEmail = prefs.getString('user_email') ?? "";
    String savedName = prefs.getString('user_name') ?? "";
    String savedPhone = prefs.getString('user_phone') ?? "";

    // حساب التقييم الإجمالي لايف من الكاش الموحد
    List<String> rawRatings = prefs.getStringList('captain_ratings_pool') ?? [];
    double totalStars = 0.0;
    
    if (rawRatings.isNotEmpty) {
      for (String item in rawRatings) {
        try {
          final Map<String, dynamic> ratingData = jsonDecode(item);
          totalStars += (ratingData['stars'] ?? 0.0);
        } catch (e) {
          // لتجنب أي خطأ في قراءة الكاش القديم
        }
      }
    }

    setState(() {
      _userEmail = savedEmail;
      _userPhone = savedPhone;
      
      // لو الإيميل المسجل هو إيميل الكابتن، اعرض اسم الكابتن واحسب ريتينجه
      if (_userEmail == "cap@gmail.com") {
        _userName = savedName.isNotEmpty ? savedName : "كابتن مصطفى نصر";
        
        // تحديث أرقام ريتينج الكابتن لايف بناءً على التقييمات الحالية
        if (rawRatings.isNotEmpty) {
          _captainTotalRatings = 120 + rawRatings.length;
          _captainAverageRating = totalStars / rawRatings.length;
        }
      } else {
        // إذا كان مستخدم عادي أو أدمن يقرأ اسمه الفعلي من الكاش، وإذا كان فارغاً نضع اسم افتراضي سليم
        _userName = savedName.isNotEmpty ? savedName : "مستخدم بدّال";
      }
    });
  }

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
                    backgroundColor: primaryGreen.withValues(alpha: 0.1),
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
              
              // عرض الاسم الديناميكي المربوط بالحالة الحالية
              Text(
                _userName, 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: navyBlue),
              ),
              const SizedBox(height: 4),
              
              // عرض البيانات الفرعية (الإيميل لو متاح، وإذا كان فارغاً يعرض رقم الهاتف لمنع التعليق)
              Text(
                _userEmail.isNotEmpty ? _userEmail : _userPhone, 
                style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              
              // 💡 عرض التقييم الكلي والنجوم لايف للكابتن فقط
              if (_userEmail == "cap@gmail.com") ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                    const SizedBox(width: 4),
                    Text(
                      "${_captainAverageRating.toStringAsFixed(1)} ($_captainTotalRatings رحلة)",
                      style: const TextStyle(color: navyBlue, fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
              
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
                      onTap: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                        _loadUserData(); 
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

              // فحص الأدمن التلقائي بحسب الإيميل المقروء والمطابق للوحة التحكم الحالية لقفل الأمان
              if (_userEmail == adminEmail) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: navyBlue.withValues(alpha: 0.05),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
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

              // --- زر تسجيل الخروج الآمن والكامل ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    // مسح شامل لكل بيانات الكاش لمنع تداخل الجلسات وظهور بيانات أي مستخدم آخر
                    await prefs.clear(); 

                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    }
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
          color: primaryGreen.withValues(alpha: 0.08),
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