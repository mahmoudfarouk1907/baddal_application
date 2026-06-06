import 'package:flutter/material.dart';
import 'login_screen.dart'; // عشان ينقلنا لصفحة اللوج إن لما نخلص
import 'main_layout.dart'; // عشان ينقلنا للصفحة الرئيسية لما نضغط تخطي
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "مش فاضي؟ بدّال بدالك",
      "desc": "بنخلص لك كل مشاويرك وطلباتك وأنت مرتاح في مكانك.",
    },
    {
      "title": "توصيل سريع وأمان",
      "desc": "أقرب كابتن ليك هيتحرك فوراً وهتوصلك حاجتك بأعلى أمان.",
    },
    {
      "title": "خدمات طبية وحجز دكتور",
      "desc": "مش بس طلبات، إحنا بنقرب لك الرعاية الطبية لحد باب بيتك.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // زر التخطي (Skip)
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainLayout()),
                  );
                },
                child: const Text("تخطي", style: TextStyle(color: Colors.green, fontSize: 16)),
              ),
            ),
            
            // صفحات الـ Onboarding
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // مكان صورة اللوجو الأخضر بتاع بدّال
                        Image.asset(
                          'assets/baddal.green.logo.png',
                          height: 180,
                          errorBuilder: (context, error, stackTrace) {
                            // لو الصورة لسه محطتهاش هيظهر بدالها شكل افتراضي رايق وميكسرش الأبليكيشن
                            return const Icon(Icons.delivery_dining, size: 100, color: Colors.green);
                          },
                        ),
                        const SizedBox(height: 40),
                        Text(
                          _onboardingData[index]["title"]!,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _onboardingData[index]["desc"]!,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // النقط اللي تحت (Indicators) والزرار
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.green : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // زرار التالي أو ابدأ الآن
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_currentPage == _onboardingData.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Text(
                    _currentPage == _onboardingData.length - 1 ? "ابدأ الآن" : "التالي",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}