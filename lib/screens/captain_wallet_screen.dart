// lib/screens/captain_wallet_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaptainWalletScreen extends StatefulWidget {
  const CaptainWalletScreen({super.key});

  @override
  State<CaptainWalletScreen> createState() => _CaptainWalletScreenState();
}

class _CaptainWalletScreenState extends State<CaptainWalletScreen> {
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);
  
  double _balance = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWalletBalance();
  }

  // دالة قراءة الرصيد الحالي للمحفظة من الـ SharedPreferences
  Future<void> _loadWalletBalance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _balance = prefs.getDouble('captain_wallet_balance') ?? 0.0;
      _isLoading = false;
    });
  }

  // دالة طلب سحب الرصيد وفحص شرط الـ 100 جنيه
  void _handleWithdrawal() {
    if (_balance < 100) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("عذراً يا كابتن ⚠️", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue)),
          content: const Text(
            "الحد الأدنى لطلب سحب الأرباح هو 100 جنيه. كمّل أوردراتك وعاش يا بطل! 💪",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("حسناً، فهمت", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      );
    } else {
      // لو رصيده 100 جنيه أو أكتر، بيسمح له بالسحب ويصفر المحفظة (أو يبعت طلب للإدارة)
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("تأكيد السحب 💸", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue)),
          content: Text("هل تريد سحب مبلغ ${_balance.toStringAsFixed(0)} جنيه كاش؟", textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setDouble('captain_wallet_balance', 0.0); // تصغير المحفظة بعد السحب
                _loadWalletBalance(); // إعادة تحميل الشاشة لتحديث الرصيد لـ 0
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("🚀 تم إرسال طلب السحب للإدارة، سيتم تحويل أموالك خلال 24 ساعة!"),
                      backgroundColor: primaryGreen,
                    ),
                  );
                }
              },
              child: const Text("تأكيد السحب", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: primaryGreen))
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // كارد عرض الرصيد الاحترافي للكابتن
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [navyBlue, Color(0xFF1E293B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: navyBlue.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 8))
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text("إجمالي أرباحك الجاهزة للسحب", style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 12),
                          Text(
                            "${_balance.toStringAsFixed(2)} ج.م",
                            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'sans-serif'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // كارد تنبيه شروط السحب
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber.shade200),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline_rounded, color: Colors.amber),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "تنبيه: الحد الأدنى للسحب من المحفظة هو 100 جنيه مصري.",
                              style: TextStyle(color: navyBlue, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    
                    // زر طلب السحب
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        onPressed: _handleWithdrawal,
                        icon: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white),
                        label: const Text("طلب سحب الأرباح كاش", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
      ),
    );
  }
}