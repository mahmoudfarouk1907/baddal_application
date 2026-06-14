import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; // استيراد المكتبة لإرسال التقييم
import 'dart:convert'; // لتحويل قائمة التعليقات لنصوص

class ActiveOrderTrackingScreen extends StatefulWidget {
  const ActiveOrderTrackingScreen({super.key});

  @override
  State<ActiveOrderTrackingScreen> createState() => _ActiveOrderTrackingScreenState();
}

class _ActiveOrderTrackingScreenState extends State<ActiveOrderTrackingScreen> {
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color backgroundColor = Color(0xFFF8FAFC);

  final String captainPhone = "+201012345678"; 
  final int _currentStep = 1;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    var whatsappUrl = "https://wa.me/$phoneNumber";
    final Uri launchUri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    }
  }

  // 🚨 فانكشن إظهار نافذة تأكيد إلغاء الطلب من قِبل المستخدم
  void _showCancelOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                SizedBox(width: 8),
                Text('إلغاء الطلب', style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue)),
              ],
            ),
            content: const Text(
              'هل أنت متأكد من رغبتك في إلغاء هذا الطلب؟ لا يمكن التراجع عن هذا الإجراء.',
              style: TextStyle(fontSize: 15, height: 1.4, color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('تراجع', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(dialogContext); // إغلاق الديالوج
                  
                  final prefs = await SharedPreferences.getInstance();
                  // حفظ حالة الإلغاء في الكاش لتسمع في باقي الشاشات
                  await prefs.setString('active_order_status', 'cancelled');
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم إلغاء الطلب بنجاح', style: TextStyle(fontWeight: FontWeight.bold)),
                        backgroundColor: Colors.red,
                      ),
                    );
                    Navigator.pop(context); // العودة للشاشة السابقة بعد الإلغاء مباشرة
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('نعم، إلغاء', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  // 💡 فانكشن إظهار نافذة التقييم الروقان للعميل
  void _showRatingBottomSheet(BuildContext context) {
    int selectedStars = 5; // القيمة الافتراضية للنجوم
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 24,
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // شريط سحب البوتوم شيت
                    Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(height: 20),
                    const Text("تقييم الكابتن", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: navyBlue)),
                    const SizedBox(height: 8),
                    const Text("كيف كانت تجربتك مع كابتن مصطفى نصر؟", style: TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 20),

                    // النجوم التفاعلية (1 إلى 5)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setModalState(() {
                              selectedStars = index + 1;
                            });
                          },
                          icon: Icon(
                            index < selectedStars ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: Colors.amber,
                            size: 40,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),

                    // حقل كتابة التعليق الشخصي
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "اكتب رأيك في الكابتن (مستحب)...",
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: primaryGreen, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // زرار الإرسال والحفظ
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          // لوجيك حفظ التقييم بشكل مجهول في الكاش
                          final prefs = await SharedPreferences.getInstance();
                          
                          // 1. جلب التقييمات السابقة
                          List<String> currentRatings = prefs.getStringList('captain_ratings_pool') ?? [];
                          
                          // 2. تجهيز داتا التقييم الجديد (بدون أي ذكر لاسم أو إيميل العميل)
                          Map<String, dynamic> newRating = {
                            'stars': selectedStars,
                            'comment': commentController.text.trim(),
                            'timestamp': DateTime.now().toString(),
                          };

                          currentRatings.add(jsonEncode(newRating));
                          await prefs.setStringList('captain_ratings_pool', currentRatings);

                          if (context.mounted) {
                            Navigator.pop(context); // إغلاق شيت التقييم
                            Navigator.pop(context); // إغلاق صفحة التتبع لأن الأوردر انتهى
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('شكراً لك! تم إرسال تقييمك بنجاح ومجهول الهوية.', style: TextStyle(fontWeight: FontWeight.bold)),
                                backgroundColor: primaryGreen,
                              ),
                            );
                          }
                        },
                        child: const Text("إرسال التقييم", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
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
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: primaryGreen.withValues(alpha: 0.1),
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
                    
                    // أزرار التواصل
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
                            onPressed: () => _makePhoneCall(captainPhone), 
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
                            onPressed: () => _openWhatsApp(captainPhone), 
                            icon: const Icon(Icons.chat, color: navyBlue, size: 18), 
                            label: const Text("واتساب", style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 🚨 زرار إلغاء الطلب الحالي المضاف بالتنسيق المظبوط مع التصميم
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => _showCancelOrderDialog(context),
                  icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 20),
                  label: const Text(
                    "إلغاء الطلب الحالي",
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.red.withValues(alpha: 0.02),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 💡 زر محاكاة إتمام الطلب من طرف الكابتن لإظهار نافذة التقييم تجريبياً
              SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: navyBlue.withValues(alpha: 0.05),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _showRatingBottomSheet(context),
                  icon: const Icon(Icons.verified_rounded, color: navyBlue),
                  label: const Text(
                    "محاكاة إتمام وتوصيل الطلب (عرض التقييم)",
                    style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
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
                border: isCompleted ? Border.all(color: primaryGreen.withValues(alpha: 0.2), width: 4) : null,
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
              Text(subtitle, style: TextStyle(color: isCompleted ? navyBlue.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.6), fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
            ],
          ),
        )
      ],
    );
  }
}