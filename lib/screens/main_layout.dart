import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'doctor_screen.dart';
import 'profile_screen.dart'; // تأكد أن الكلاس داخل هذا الملف اسمه ProfileScreen بالظبط

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // الإصلاح هنا: إضافة const لأن ProfileScreen كلاس ثابت
  final List<Widget> _screens = [
    const HomeScreen(),
    const DoctorScreen(),
    const ProfileScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    const navyBlue = Color(0xFF0F172A);
    const primaryGreen = Color(0xFF22C55E);

    return Scaffold(
      extendBody: true, 
      body: _screens[_selectedIndex],
      
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
        child: Container(
          height: 65, // زيادة الطول لضمان عدم حدوث Overflow مع الخطوط السميكة
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08), 
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.directions_bike_outlined, Icons.directions_bike_rounded, 'التوصيل', primaryGreen, navyBlue),
              _buildNavItem(1, Icons.local_hospital_outlined, Icons.local_hospital_rounded, 'الطبيب', primaryGreen, navyBlue),
              _buildNavItem(2, Icons.person_outline_rounded, Icons.person_rounded, 'حسابي', primaryGreen, navyBlue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData normalIcon, IconData activeIcon, String label, Color activeColor, Color inactiveColor) {
    bool isSelected = _selectedIndex == index;
    
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : normalIcon,
                color: isSelected ? activeColor : inactiveColor.withValues(alpha: 0.5),
                size: 28, // تكبير بسيط لسهولة الرؤية
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? activeColor : inactiveColor.withValues(alpha: 0.7),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w700, // زيادة سمك الخط
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}