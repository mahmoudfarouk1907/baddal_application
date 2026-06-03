import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // دالة لحفظ أن المستخدم شاف الشاشات دي وم تظهرش تاني
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    
    if (mounted) {
      // Use named route to avoid depending on a specific class name in login_screen.dart
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF22C55E);
    const navyBlue = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // زر التخطي (Skip) في الأعلى
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: _completeOnboarding,
                child: const Text(
                  'تخطي',
                  style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // الصفحات الثلاثة مدمجة مع حركة السحب
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  // الصفحة الأولى: اللوجو والكلمة السحرية
                  _buildPage(
                    imagePath: 'assets/baddal.green.logo.png', // حط الصورة في فولدر الـ assets عندك
                    title: 'Baddal | بدّال',
                    subtitle: '“مش فاضي بدّال بدالك”',
                    isFirstPage: true,
                  ),
                  // الصفحة الثانية: شرح الخدمة الأولى
                  _buildPage(
                    imagePath: 'assets/baddal.green.logo.png', // تقدر تغيرها لصور توضيحية بعدين
                    title: 'توصيل سريع وذكي',
                    subtitle: 'بنربطك بأقرب كابتن في أجا والدقهلية عشان طلباتك تلمس باب بيتك في دقائق معدودة وبأمان كامل.',
                    isFirstPage: false,
                  ),
                  // الصفحة الثالثة: شرح الخدمة الثانية (حجز العيادات والأسعار المتغيرة)
                  _buildPage(
                    imagePath: 'assets/baddal.green.logo.png',
                    title: 'مشاويرك الطبية أسهل',
                    subtitle: 'احجز مواعيد عيادتك ودكتورك المفضل مباشرة من التطبيق مع ميزة تحديد الأسعار المرنة حسب وقت الانتظار.',
                    isFirstPage: false,
                  ),
                ],
              ),
            ),

            // النقاط السفلية وزر الانتقال
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // المؤشرات (Dots)
                  Row(
                    children: List.generate(
                      3,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 6),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? primaryGreen : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  // زر التالي أو ابدأ الآن
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == 2) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: navyBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text(
                      _currentPage == 2 ? 'ابدأ الآن' : 'التالي',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت مخصصة لبناء تصميم كل صفحة بشكل نظيف وموحد
  Widget _buildPage({required String imagePath, required String title, required String subtitle, required bool isFirstPage}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 220,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isFirstPage ? 20 : 15,
              fontWeight: isFirstPage ? FontWeight.w900 : FontWeight.normal,
              color: isFirstPage ? const Color(0xFF15803D) : Colors.grey[600],
              fontStyle: isFirstPage ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}