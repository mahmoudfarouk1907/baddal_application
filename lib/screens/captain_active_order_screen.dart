import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaptainActiveOrderScreen extends StatefulWidget {
  final String orderId;
  final String orderType; // 'normal', 'doctor', 'station', 'extra_hour'
  final double orderPrice; // سعر الأوردر الإجمالي (25, 30, 50, 100, 7)

  const CaptainActiveOrderScreen({
    super.key, 
    required this.orderId,
    required this.orderType,
    required this.orderPrice,
  });

  @override
  State<CaptainActiveOrderScreen> createState() => _CaptainActiveOrderScreenState();
}

class _CaptainActiveOrderScreenState extends State<CaptainActiveOrderScreen> {
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);

  int _currentStep = 0;
  final List<String> _stepsTitles = ["في الطريق للمتجر", "تم استلام الطلب", "جاري التوصيل للعميل"];
  final List<String> _buttonTexts = ["تأكيد الوصول والاستلام 🛍️", "بدء التحرك للتوصيل 🚴‍♂️", "تأكيد تسليم الأوردر بنجاح ✅"];

  final String _customerPhone = "01000000000"; 

  // دالة حسبة ربح الكابتن الذكية بناءً على شروطك
  double _calculateCaptainProfit() {
    if (widget.orderType == 'normal') {
      if (widget.orderPrice == 25) return 20.0;
      if (widget.orderPrice == 30) return 25.0;
    } else if (widget.orderType == 'station' && widget.orderPrice == 7) {
      return 5.0;
    } else if (widget.orderType == 'doctor') {
      if (widget.orderPrice == 50) return 40.0;
      if (widget.orderPrice == 100) return 80.0;
    } else if (widget.orderType == 'extra_hour' && widget.orderPrice == 25) {
      return 20.0;
    }
    // حسبة افتراضية لو السعر متغير (الكابتن يصح لية 80% من الإجمالي كمثال احتياطي)
    return widget.orderPrice * 0.8; 
  }

  // دالة حفظ الأرباح في محفظة الكابتن المحلية
  Future<void> _saveProfitToWallet(double profit) async {
    final prefs = await SharedPreferences.getInstance();
    double currentBalance = prefs.getDouble('captain_wallet_balance') ?? 0.0;
    await prefs.setDouble('captain_wallet_balance', currentBalance + profit);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    String formattedNumber = phoneNumber;
    if (phoneNumber.startsWith('01')) {
      formattedNumber = '20${phoneNumber.substring(1)}';
    }
    String message = Uri.encodeComponent("السلام عليكم يا فندم، أنا كابتن تطبيق بدال وقريب من موقعك.");
    final Uri whatsappUri = Uri.parse("https://wa.me/$formattedNumber?text=$message");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  void _nextStep() async {
    if (_currentStep < _stepsTitles.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // حساب وحفظ الأرباح عند إغلاق الأوردر بنجاح
      double captainProfit = _calculateCaptainProfit();
      await _saveProfitToWallet(captainProfit);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("عاش يا كابتن! تم إغلاق الطلب وإضافة ${captainProfit.toStringAsFixed(0)} جنيه لمحفظتك ✨"), 
            backgroundColor: primaryGreen,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("طلب نشط ${widget.orderId}", style: const TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navyBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: primaryGreen.withValues(alpha: 0.1),
                      child: const Icon(Icons.person, color: primaryGreen, size: 28),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("أستاذ محمد أحمد (العميل)", style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 15)),
                          SizedBox(height: 4),
                          Text("أجا - شارع فهمي وبجوار مدرسة التجارة", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF25D366), size: 26),
                          onPressed: () => _openWhatsApp(_customerPhone),
                        ),
                        IconButton(
                          icon: const Icon(Icons.phone_in_talk_rounded, color: primaryGreen, size: 26),
                          onPressed: () => _makePhoneCall(_customerPhone),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text("حالة الطلب الحالية:", style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 16),
              ...List.generate(_stepsTitles.length, (index) {
                bool isDone = index < _currentStep;
                bool isCurrent = index == _currentStep;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDone || isCurrent ? primaryGreen : Colors.grey.shade300,
                          ),
                          child: Icon(isDone ? Icons.check : Icons.radio_button_checked, size: 14, color: Colors.white),
                        ),
                        if (index != _stepsTitles.length - 1)
                          Container(width: 2, height: 40, color: isDone ? primaryGreen : Colors.grey.shade300),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        _stepsTitles[index],
                        style: TextStyle(
                          color: isCurrent ? primaryGreen : (isDone ? navyBlue : Colors.grey),
                          fontWeight: isCurrent || isDone ? FontWeight.bold : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentStep == 2 ? const Color(0xFFEF4444) : primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: _nextStep,
                  child: Text(_buttonTexts[_currentStep], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}