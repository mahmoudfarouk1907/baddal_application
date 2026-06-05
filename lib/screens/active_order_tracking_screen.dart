import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // مكتبة الفتح الخارجي

class ActiveOrderTrackingScreen extends StatefulWidget {
  const ActiveOrderTrackingScreen({super.key});

  @override
  State<ActiveOrderTrackingScreen> createState() => _ActiveOrderTrackingScreenState();
}

class _ActiveOrderTrackingScreenState extends State<ActiveOrderTrackingScreen> {
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color backgroundColor = Color(0xFFF8FAFC);

  // بيانات الكابتن (للتجربة)
  final String captainPhone = "+201012345678"; // حط هنا رقم الكابتن الحقيقي من الداتا

  int _currentStep = 1;

  // وظيفة الاتصال الهاتفي
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  // وظيفة فتح الواتساب
  Future<void> _openWhatsApp(String phoneNumber) async {
    // تنسيق الرابط للواتساب
    var whatsappUrl = "https://wa.me/$phoneNumber";
    final Uri launchUri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("تتبع طلبك الحيوى", style: TextStyle(color: navyBlue, fontWeight: FontWeight.w900, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navyBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // كارت حالة المشوار
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("وقت الوصول المتوقع", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13)),
                        Text("12 - 15 دقيقة", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w900, fontSize: 16)),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
                    _buildTrackingStep(0, "تم قبول طلبك", "الكابتن استلم الطلب وجاري التحرك", isCompleted: _currentStep >= 0),
                    _buildTrackingStep(1, "جاري تجهيز وتوصيل الطلب", "الكابتن في طريقه إليك الآن بالأغراض", isCompleted: _currentStep >= 1),
                    _buildTrackingStep(2, "وصل الكابتن موقعك", "برجاء الخروج لاستلام الطلب من الكابتن", isCompleted: _currentStep >= 2, isLast: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // كارت الكابتن
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: primaryGreen.withOpacity(0.1),
                          child: const Icon(Icons.person_rounded, color: primaryGreen, size: 32),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("كابتن مصطفى نصر", style: TextStyle(fontWeight: FontWeight.w900, color: navyBlue, fontSize: 16)),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                  SizedBox(width: 4),
                                  Text("4.9 (120 رحلة)", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8)),
                          child: const Row(
                            children: [
                              Icon(Icons.directions_bike_rounded, color: navyBlue, size: 16),
                              SizedBox(width: 4),
                              Text("عجلة", style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        )
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider()),
                    
                    // أزرار التواصل (المعدلة)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              minimumSize: const Size.fromHeight(46),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => _makePhoneCall(captainPhone), // تفعيل الاتصال
                            icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white, size: 18),
                            label: const Text("اتصال هاتفى", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: navyBlue, width: 1.5),
                              minimumSize: const Size.fromHeight(46),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => _openWhatsApp(captainPhone), // تفعيل الواتساب
                            icon: const Icon(Icons.chat, color: navyBlue, size: 18), // أيقونة دردشة بديلة
                            label: const Text("واتساب", style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // تم حذف زرار "إلغاء الطلب" من هنا تماماً
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingStep(int index, String title, String subtitle, {required bool isCompleted, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted ? primaryGreen : Colors.grey.shade200,
                shape: BoxShape.circle,
                border: isCompleted ? Border.all(color: primaryGreen.withOpacity(0.2), width: 4) : null,
              ),
              child: isCompleted ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
            ),
            if (!isLast)
              Container(width: 2, height: 45, color: isCompleted ? primaryGreen : Colors.grey.shade200),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w900, color: isCompleted ? navyBlue : Colors.grey, fontSize: 14)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: isCompleted ? navyBlue.withOpacity(0.5) : Colors.grey.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
            ],
          ),
        )
      ],
    );
  }
}