// lib/screens/admin_deposits_dashboard.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart'; // 🛑 تأكد من استيراد شاشة اللوج إن الخاصة بمشروعك هنا

class AdminDepositsDashboard extends StatefulWidget {
  const AdminDepositsDashboard({super.key});

  @override
  State<AdminDepositsDashboard> createState() => _AdminDepositsDashboardState();
}

class _AdminDepositsDashboardState extends State<AdminDepositsDashboard> with SingleTickerProviderStateMixin {
  static const Color adminNavy = Color(0xFF1E293B);
  static const Color accentGreen = Color(0xFF22C55E);

  List<Map<String, dynamic>> _pendingRequests = [];
  List<Map<String, dynamic>> _approvedHistory = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getDepositRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _getDepositRequests() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    List<String> rawPool = prefs.getStringList('admin_deposit_requests_pool') ?? [];
    
    List<Map<String, dynamic>> pendingList = [];
    List<Map<String, dynamic>> approvedList = [];
    
    // قراءة البيانات وعكسها ليظهر الأحدث فوق
    for (String item in rawPool.reversed) {
      Map<String, dynamic> req = Map<String, dynamic>.from(jsonDecode(item));
      if (req['status'] == 'pending') {
        pendingList.add(req);
      } else {
        approvedList.add(req);
      }
    }
    
    setState(() {
      _pendingRequests = pendingList;
      _approvedHistory = approvedList;
      _isLoading = false;
    });
  }

  // معالجة موافقة الأدمن وتعديل محفظة الكابتن والتعامل مع الرصيد الزائد
  Future<void> _approveRequest(String requestId, double finalApprovedAmount, String captainEmail) async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. تحديث محفظة الكابتن الفعلي بناءً على القيمة المدخلة من الأدمن
    double currentCaptainBalance = prefs.getDouble('captain_wallet_balance') ?? -150.0;
    
    // الحسبة الحسابية: (المديونية بالسالب + الإيداع الجديد)
    double newBalance = currentCaptainBalance + finalApprovedAmount;
    
    await prefs.setDouble('captain_wallet_balance', newBalance);
    // إلغاء حظر الكابتن لو مديونيته أصبحت أفضل من -500 جنيه
    await prefs.setBool('is_captain_blocked', newBalance <= -500.0);

    // 2. تحديث حالة الطلب في قائمة الأدمن إلى المقبول
    List<String> rawPool = prefs.getStringList('admin_deposit_requests_pool') ?? [];
    List<String> updatedPool = [];
    
    for (String item in rawPool) {
      Map<String, dynamic> req = Map<String, dynamic>.from(jsonDecode(item));
      if (req['id'] == requestId) {
        req['status'] = 'approved';
        req['amountApproved'] = finalApprovedAmount;
      }
      updatedPool.add(jsonEncode(req));
    }
    
    await prefs.setStringList('admin_deposit_requests_pool', updatedPool);
    _getDepositRequests(); // إعادة تحميل القوائم المتأثرة

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ تم اعتماد التوريد بنجاح وتحديث محفظة الكابتن!"),
          backgroundColor: accentGreen,
        ),
      );
    }
  }

  // 🚪 دالة تسجيل الخروج وتنظيف الكاش الأمني
  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_role'); // مسح الرول لمنع الدخول التلقائي بدون صلاحية
    
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()), // التوجيه لصفحة الـ Login
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          "لوحة مراجعة كاش التوريدات 👑", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
        ),
        backgroundColor: adminNavy,
        centerTitle: true,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
          tooltip: "تسجيل الخروج",
          onPressed: () {
            // إظهار تأكيد قبل تسجيل الخروج لمزيد من الأمان للأدمن
            showDialog(
              context: context,
              builder: (context) => Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  title: const Text("تسجيل الخروج"),
                  content: const Text("هل أنت متأكد من رغبتك في تسجيل الخروج من لوحة الإدارة؟"),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleLogout();
                      },
                      child: const Text("خروج", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _getDepositRequests,
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: accentGreen,
          unselectedLabelColor: Colors.white60,
          indicatorColor: accentGreen,
          indicatorWeight: 3,
          tabs: const [
            Tab(icon: Icon(Icons.pending_actions_rounded), text: "طلبات معلقة"),
            Tab(icon: Icon(Icons.history_toggle_off_rounded), text: "سجل المعتمدات"),
          ],
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: adminNavy))
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildRequestsList(_pendingRequests, isPendingTab: true),
                  _buildRequestsList(_approvedHistory, isPendingTab: false),
                ],
              ),
      ),
    );
  }

  // بناء القائمة أو عرض الـ Empty State المتناسق والجميل
  Widget _buildRequestsList(List<Map<String, dynamic>> list, {required bool isPendingTab}) {
    if (list.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isPendingTab ? Colors.amber.shade50 : Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPendingTab ? Icons.all_inclusive_rounded : Icons.folder_off_rounded,
                    size: 70,
                    color: isPendingTab ? Colors.amber.shade700 : Colors.green.shade600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isPendingTab ? "الرايق كسبان! القائمة نظيفة ✨" : "السجل فارغ تماماً 📄",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: adminNavy),
                ),
                const SizedBox(height: 8),
                Text(
                  isPendingTab 
                      ? "لا توجد أي طلبات توريد كاش معلقة حالياً بانتظار المراجعة."
                      : "لم يتم اعتماد أو توثيق أي عمليات إيداع كاش حتى هذه اللحظة.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final req = list[index];
        bool isPending = req['status'] == 'pending';
        final TextEditingController adminAmountController = TextEditingController(text: req['amountSent'].toString());

        return Card(
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "كابتن: ${req['captainEmail']}", 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: adminNavy, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPending ? Colors.amber.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Text(
                        isPending ? "معلق للمراجعة ⏱️" : "تم التأكيد ✅", 
                        style: TextStyle(
                          color: isPending ? Colors.amber.shade900 : accentGreen, 
                          fontSize: 11, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                    )
                  ],
                ),
                const Divider(height: 24, thickness: 0.5),
                Text("📱 رقم عملية الكابتن: ${req['transactionNumber']}", style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Text("📅 تاريخ الإرسال: ${req['date']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 6),
                Text("💰 المبلغ المكتوب بواسطة الكابتن: ${req['amountSent']} ج.م", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: adminNavy)),
                
                if (isPending) ...[
                  const SizedBox(height: 14),
                  const Text("تأكيد المبلغ المستلم الفعلي في فودافون كاش الخاص بك:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: TextField(
                            controller: adminAmountController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: adminNavy, width: 1.5)
                              ),
                              hintText: "اكتب المبلغ الفعلي"
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentGreen, 
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        onPressed: () {
                          double? finalAmt = double.tryParse(adminAmountController.text.trim());
                          if (finalAmt == null || finalAmt <= 0) return;
                          _approveRequest(req['id'], finalAmt, req['captainEmail']);
                        },
                        child: const Text("تأكيد الاعتماد", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      )
                    ],
                  )
                ] else ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade100) // حواف خفيفة لتأطير البيانات الهامة في الهيستوري
                    ),
                    child: Text(
                      "💵 المبلغ الفعلي المعتمد بواسطة الأدمن: ${req['amountApproved']} ج.م", 
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green, fontFamily: 'sans-serif')
                    ),
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}