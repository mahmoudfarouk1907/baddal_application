// lib/screens/captain_wallet_screen.dart

import 'dart:convert';
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
  static const Color debtColor = Color(0xFF991B1B); 

  final String appVodafoneCashNumber = "01069497751";
  final _formKey = GlobalKey<FormState>();
  final _transactionController = TextEditingController();
  final _amountController = TextEditingController();

  double _balance = 0.0;
  bool _isLoading = true;
  bool _hasHighDebt = false;
  bool _isImageSelected = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadWalletBalance();
  }

  @override
  void dispose() {
    _transactionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadWalletBalance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _balance = prefs.getDouble('captain_wallet_balance') ?? -150.0; // مديونية افتراضية للتجربة
      _hasHighDebt = _balance <= -500.0;
      _isLoading = false;
    });
  }

  void _toggleBalanceForTesting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_balance >= 0) {
        _balance = -150.0; 
      } else if (_balance == -150.0) {
        _balance = -550.0; 
      } else {
        _balance = 20.0; 
      }
      _hasHighDebt = _balance <= -500.0;
    });
    await prefs.setDouble('captain_wallet_balance', _balance);
  }

  // دالة حفظ طلب التوريد في صندوق مشترك ليراه الأدمن
  Future<void> _submitToAdminPool() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isImageSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ يرجى الضغط على زر رفع الإيصال أولاً!"), backgroundColor: Colors.amber, behavior: SnackBarBehavior.floating),
      );
      return;
    }

    setState(() { _isSubmitting = true; });
    await Future.delayed(const Duration(milliseconds: 1500)); // محاكاة الرفع

    final prefs = await SharedPreferences.getInstance();
    
    // إنشاء كائن الطلب الجديد
    Map<String, dynamic> newRequest = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'captainEmail': 'cap@gmail.com',
      'transactionNumber': _transactionController.text.trim(),
      'amountSent': double.tryParse(_amountController.text.trim()) ?? _balance.abs(),
      'date': DateTime.now().toString().substring(0, 16),
      'status': 'pending'
    };

    // جلب الطلبات القديمة وإضافة الجديد
    List<String> adminPool = prefs.getStringList('admin_deposit_requests_pool') ?? [];
    adminPool.add(jsonEncode(newRequest));
    await prefs.setStringList('admin_deposit_requests_pool', adminPool);

    setState(() {
      _isSubmitting = false;
      _isImageSelected = false;
      _transactionController.clear();
      _amountController.clear();
    });

    if (mounted) {
      showDialog(
        context: context,
        builder: (ctx) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text("تم إرسال الإيصال بفضل الله 🎉", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 16), textAlign: TextAlign.center),
            content: const Text(
              "تم إرسال بيانات الإيصال والمبلغ بنجاح إلى لوحة تحكم الأدمن.\n\n⏱️ جاري مراجعة التحويل يدويًا وتفعيل حسابك خلال دقائق معدودة.",
              style: TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF475569)),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("حسناً", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)))
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDebt = _balance < 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("محفظتي الحسابية", style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horizontal_circle_outlined, color: navyBlue, size: 26),
            onPressed: _loadWalletBalance, // زرار تحديث يدوي للمحفظة لرؤية موافقة الأدمن لايف!
          ),
          IconButton(
            icon: const Icon(Icons.bolt, color: Colors.amber, size: 24),
            onPressed: _toggleBalanceForTesting, // زرار التغيير السريع للتجربة
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: primaryGreen))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- كارت الرصيد ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _hasHighDebt ? [debtColor, const Color(0xFF450A0A)] : [navyBlue, const Color(0xFF1E293B)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: navyBlue.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))],
                      ),
                      child: Column(
                        children: [
                          Text(
                            isDebt ? "إجمالي عمولة المنصة المستحقة (مديونية)" : "إجمالي رصيدك الحالي (إيداع مسبق)", 
                            style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "${_balance.abs().toStringAsFixed(2)} ج.م",
                            style: TextStyle(color: isDebt ? Colors.white : primaryGreen, fontSize: 34, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- نوت الرصيد الإضافي الذكية ---
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: Colors.blue.withOpacity(0.06), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.blue.shade100)),
                      child: const Row(
                        children: [
                          Icon(Icons.lightbulb_outline_rounded, color: Colors.blue, size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "💡 ميزة الكابتن المستقبلي: يمكنك تحويل مبلغ أكبر من مديونيتك الحالية، وسيتم حفظ الزرائد تلقائياً كرصيد إضافي لك لتستمر في العمل دون توقف حسابك مستقبلاً.",
                              style: TextStyle(color: navyBlue, fontSize: 11, fontWeight: FontWeight.w500, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (isDebt) ...[
                      const Text("إجراءات توريد المستحقات كاش:", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 15)),
                      const SizedBox(height: 12),
                      
                      // خطوات التوريد المكتوبة مباشرة في الصفحة
                      _buildInlineStep("1", "انسخ رقم فودافون كاش الخاص بالإدارة وحوّل المديونية غليه:"),
                      Container(
                        margin: const EdgeInsets.only(right: 34, top: 6, bottom: 14),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(appVodafoneCashNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: navyBlue, letterSpacing: 1.2)),
                            IconButton(icon: const Icon(Icons.copy_rounded, color: primaryGreen, size: 18), padding: EdgeInsets.zero, constraints: const BoxConstraints(), onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("📋 تم نسخ رقم الإدارة بنجاح!"), behavior: SnackBarBehavior.floating));
                            }),
                          ],
                        ),
                      ),
                      
                      _buildInlineStep("2", "خذ لقطة شاشة (Screenshot) وافتح معرض الصور لارفاقها بالأسفل:"),
                      const SizedBox(height: 12),

                      // استمارة الرفع بداخل الصفحة مباشرة
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () { setState(() { _isImageSelected = true; }); },
                              child: Container(
                                width: double.infinity,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: _isImageSelected ? Colors.green.withOpacity(0.02) : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: _isImageSelected ? primaryGreen : Colors.grey.shade300, style: BorderStyle.solid),
                                ),
                                child: _isImageSelected
                                    ? const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.check_circle, color: primaryGreen), SizedBox(width: 8), Text("تم إرفاق إيصال التحويل بنجاح!", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 13))])
                                    : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.cloud_upload_outlined, color: Colors.grey), SizedBox(width: 8), Text("اضغط هنا لإرفاق صورة الإيصال", style: TextStyle(fontSize: 13, color: navyBlue, fontWeight: FontWeight.w500))]),
                              ),
                            ),
                            const SizedBox(height: 14),
                            
                            // حقل كتابة المبلغ الفعلي المحول
                            TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration("المبلغ الذي قمت بتحويله فعلياً (ج.م) *"),
                              validator: (v) => (v == null || v.isEmpty) ? "برجاء كتابة المبلغ المحول" : null,
                            ),
                            const SizedBox(height: 12),

                            // حقل رقم الهاتف المحول منه
                            TextFormField(
                              controller: _transactionController,
                              keyboardType: TextInputType.phone,
                              decoration: _inputDecoration("رقم الهاتف المحول منه أو رقم العملية *"),
                              validator: (v) => (v == null || v.isEmpty) ? "برجاء إدخال رقم التأكيد" : null,
                            ),
                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: navyBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                                onPressed: _isSubmitting ? null : _submitToAdminPool,
                                child: _isSubmitting 
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text("تأكيد وإرسال للإدارة للمراجعة 📄", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ] else ...[
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(Icons.check_circle_outline_rounded, color: primaryGreen, size: 60),
                              SizedBox(height: 14),
                              Text("حسابك نشط ومحفظتك مستقرة يا كابتن! 🦅", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 14)),
                            ],
                          ),
                        ),
                      )
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInlineStep(String num, String text) {
    return Row(children: [
      CircleAvatar(radius: 11, backgroundColor: primaryGreen, child: Text(num, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: navyBlue, fontWeight: FontWeight.w500))),
    ]);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label, labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
      fillColor: Colors.white, filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryGreen)),
    );
  }
}