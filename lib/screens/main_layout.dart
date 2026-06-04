import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'doctor_screen.dart';
import 'profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DoctorScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // عشان الشاشات تفرش ورا الناف بار بنعومة
      body: _screens[_selectedIndex],
      
      // الناف بار الـ Sleek والنحيف مقرب لأطراف الشاشة
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0), // وسعنا الجناب عشان يفرش عريض
        child: Container(
          height: 56, // خليناه ارفع وشكله رقيق جداً
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20), // حواف دائرية متناسقة مع العرض
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04), // ظل خفيف ونظيف جداً
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.directions_bike_outlined, Icons.directions_bike_rounded, 'التوصيل'),
              _buildNavItem(1, Icons.local_hospital_outlined, Icons.local_hospital_rounded, 'الطبيب'),
              _buildNavItem(2, Icons.person_outline_rounded, Icons.person_rounded, 'حسابي'),
            ],
          ),
        ),
      ),
    );
  }

  // الـ Widget المعدل: التركيز باللون فقط وبدون أي خلفيات داخلية
  Widget _buildNavItem(int index, IconData normalIcon, IconData activeIcon, String label) {
    bool isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : normalIcon, // بيتحول لأيقونة مليانة لما تختارها
              color: isSelected ? Colors.green.shade700 : Colors.grey.shade400, // اللون الأخضر للأيقونة النشطة بس
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.green.shade700 : Colors.grey.shade400,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}