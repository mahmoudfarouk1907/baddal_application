import 'package:flutter/material.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E); // لون الأبلكيشن الأساسي
  static const Color backgroundColor = Color(0xFFF8FAFC);

  // المتحكمات
  final _captainNameController = TextEditingController();
  final _captainPhoneController = TextEditingController();
  final _captainVehicleController = TextEditingController();
  final _broadcastController = TextEditingController();
  final _userSearchController = TextEditingController();

  final _captainFormKey = GlobalKey<FormState>();
  final _broadcastFormKey = GlobalKey<FormState>();

  // بيانات وهمية للكباتن
  final List<Map<String, String>> _mockCaptains = [
    {"name": "كابتن مصطفى نصر", "phone": "01012345678", "vehicle": "موتوسيكل دايون"},
    {"name": "كابتن محمد علي", "phone": "01288889999", "vehicle": "عجلة ترينكس"},
  ];

  // بيانات وهمية لبلاغات السابورت (Support Tickets)
  final List<Map<String, String>> _supportTickets = [
    {"user": "أحمد محمود (عميل)", "type": "مشكلة في الحساب", "message": "الرصيد مش مسمع في المحفظة بعد الإيداع", "time": "منذ 5 دقائق"},
    {"user": "كابتن هاني سلامة", "type": "تأخر العميل", "message": "أنا واقف بقالي ربع ساعة عند نقطة الاستلام والعميل مبيصليش", "time": "منذ 20 دقيقة"},
    {"user": "منة الله كريم (عميل)", "type": "شكوى كابتن", "message": "الكابتن طلب فلوس زيادة عن الأبلكيشن", "style": "خطر", "time": "منذ ساعة"},
  ];

  // إشعارات إلغاء الأوردرات الفورية (Live Cancellations Feed)
  final List<Map<String, dynamic>> _cancelledOrdersFeed = [
    {
      "customer": "مينا عادل",
      "phone": "01044556677",
      "totalCancellations": 5, // عدد الأوردرات اللي لغاها قبل كده
      "cancelTime": "12:40 م",
      "stage": "أثناء التحضير والتجهيز"
    },
    {
      "customer": "محمد رأفت",
      "phone": "01599887766",
      "totalCancellations": 1,
      "cancelTime": "11:15 ص",
      "stage": "بعد قبول الكابتن للرحلة"
    }
  ];

  @override
  void dispose() {
    _captainNameController.dispose();
    _captainPhoneController.dispose();
    _captainVehicleController.dispose();
    _broadcastController.dispose();
    _userSearchController.dispose();
    super.dispose();
  }

  void _handleCaptainDeletion() {
    final nameInput = _captainNameController.text.trim();
    final phoneInput = _captainPhoneController.text.trim();

    final existingCaptain = _mockCaptains.firstWhere(
      (c) => c["phone"] == phoneInput,
      orElse: () => {},
    );

    if (existingCaptain.isEmpty) {
      _showSnackBar("عذراً، لا يوجد كابتن مسجل بهذا الرقم في النظام", isError: true);
    } else if (existingCaptain["name"] != nameInput) {
      final actualName = existingCaptain["name"];
      _showSnackBar("الاسم خاطئ! ولكن يوجد كابتن باسم ($actualName) يمتلك نفس رقم الهاتف", isError: true);
    } else {
      setState(() {
        _mockCaptains.remove(existingCaptain);
      });
      _showSnackBar("تمت إزالة الكابتن ($nameInput) من السيستم بنجاح");
      _captainNameController.clear();
      _captainPhoneController.clear();
      _captainVehicleController.clear();
    }
  }

  void _showDeleteConfirmation(BuildContext context, String userName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                    child: Icon(Icons.delete_forever_rounded, color: Colors.red.shade600, size: 44),
                  ),
                  const SizedBox(height: 20),
                  const Text("تأكيد حذف الحساب", style: TextStyle(fontWeight: FontWeight.w900, color: navyBlue, fontSize: 18)),
                  const SizedBox(height: 12),
                  Text(
                    "هل أنت متأكد رغبتك في حذف حساب ($userName) نهائياً؟ هذا الإجراء سيقوم بإزالة كافة بياناته ولا يمكن التراجع عنه.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue.withOpacity(0.6), fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("إلغاء", style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _showSnackBar("تم حذف حساب المستخدم بنجاح", isError: true);
                          },
                          child: const Text("حذف نهائي", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isError ? Icons.error_outline_rounded : Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 2)),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : primaryGreen,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // تم زيادتها لـ 4 لتبويب البلاغات والدعم الجديد
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text("لوحة تحكم المسؤول", style: TextStyle(color: navyBlue, fontWeight: FontWeight.w900, fontSize: 20)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navyBlue, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              // قسم الإحصائيات المطور لعرض الرحلات الكاملة والملغاة وتفاصيلها بالملي
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildAdvancedStatCard(
                            title: "الرحلات المكتملة",
                            mainValue: "1,142 رحلة",
                            subDetail: "تم التوصيل بنجاح ✔",
                            icon: Icons.check_circle_rounded,
                            color: primaryGreen,
                            bgColor: Colors.green.shade50,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildAdvancedStatCard(
                            title: "الرحلات الملغاة",
                            mainValue: "42 إلغاء",
                            // تقسيم مرحلة التحضير والإلغاء
                            subDetail: "28 بالتجهيز • 14 أثناء السير", 
                            icon: Icons.cancel_rounded,
                            color: Colors.red.shade600,
                            bgColor: Colors.red.shade50,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildStatCard("الكباتن النشطين", "${_mockCaptains.length}", Icons.directions_bike_rounded, navyBlue, Colors.grey.shade100)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard("حجوزات الأطباء", "18", Icons.medical_services_outlined, Colors.blue, Colors.blue.shade50)),
                      ],
                    ),
                  ],
                ),
              ),

              // الـ TabBar الذكي مع تلوين خلفية التبويب النشط بلون الأبلكيشن الأساسي
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  // هنا تم تلوين التبويب النشط بلون الأبلكيشن الأساسي (الأخضر البروفيشنال)
                  indicator: BoxDecoration(
                    color: primaryGreen,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                  tabs: [
                    Tab(text: "بث إشعارات", icon: Icon(Icons.campaign_rounded, size: 18)),
                    Tab(text: "الكباتن", icon: Icon(Icons.sports_motorsports_rounded, size: 18)),
                    Tab(text: "المستخدمين", icon: Icon(Icons.people_alt_rounded, size: 18)),
                    Tab(text: "البلاغات", icon: Icon(Icons.support_agent_rounded, size: 18)), // تبويب البلاغات الجديد
                  ],
                ),
              ),

              // محتويات التبويبات (TabBarView)
              Expanded(
                child: TabBarView(
                  children: [
                    // 1. تبويب البث والإشعارات
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _broadcastFormKey,
                        child: _buildSectionCard(
                          title: "بث إشعار عالمي للمنصة",
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _broadcastController,
                                maxLines: 4,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 14),
                                validator: (v) => (v == null || v.trim().isEmpty) ? "محتوى الإشعار فارغ!" : null,
                                decoration: _inputDecoration("اكتب تحديثاً أو تنبيهاً ليتم نشره لجميع مستخدمي وكباتن تطبيق بدال فوراً...", icon: Icons.chat_bubble_outline_rounded),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: navyBlue,
                                  minimumSize: const Size.fromHeight(52),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  if (_broadcastFormKey.currentState!.validate()) {
                                    _showSnackBar("تم بث الإشعار لكل مستخدمي تطبيق بدال بنجاح");
                                    _broadcastController.clear();
                                  }
                                },
                                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                                label: const Text("إرسال البث الآن", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 2. تبويب إدارة الكباتن
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _captainFormKey,
                        child: _buildSectionCard(
                          title: "تسجيل أو إزالة كابتن",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("الاسم الكامل للكابتن", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 13)),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _captainNameController,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 15),
                                validator: (v) => (v == null || v.trim().isEmpty) ? "اسم الكابتن مطلوب للإجراء" : null,
                                decoration: _inputDecoration("مثال: أحمد محمد", icon: Icons.person_outline_rounded),
                              ),
                              const SizedBox(height: 14),
                              const Text("رقم الهاتف الذكي", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 13)),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _captainPhoneController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 15),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return "رقم الهاتف مطلوب";
                                  final regExp = RegExp(r'^01[0125][0-9]{8}$');
                                  if (!regExp.hasMatch(v.trim())) return "أدخل رقم مصري صحيح مكون من 11 رقم";
                                  return null;
                                },
                                decoration: _inputDecoration("01xxxxxxxxx", icon: Icons.phone_android_rounded),
                              ),
                              const SizedBox(height: 14),
                              const Text("نوع المركبة والوسيلة", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 13)),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _captainVehicleController,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 15),
                                decoration: _inputDecoration("عجلة اقتصادية / موتوسيكل دايون", icon: Icons.directions_bike_rounded),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                                      onPressed: () {
                                        if (_captainVehicleController.text.trim().isEmpty) {
                                          _showSnackBar("يرجى كتابة نوع المركبة لإضافة الكابتن", isError: true);
                                          return;
                                        }
                                        if (_captainFormKey.currentState!.validate()) {
                                          setState(() {
                                            _mockCaptains.add({
                                              "name": _captainNameController.text.trim(),
                                              "phone": _captainPhoneController.text.trim(),
                                              "vehicle": _captainVehicleController.text.trim(),
                                            });
                                          });
                                          _showSnackBar("تم تسجيل الكابتن الجديد بنجاح");
                                          _captainNameController.clear(); _captainPhoneController.clear(); _captainVehicleController.clear();
                                        }
                                      },
                                      icon: const Icon(Icons.person_add_alt_1_rounded, size: 18, color: Colors.white),
                                      label: const Text("إضافة كابتن", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red, width: 1.5), minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                      onPressed: () { if (_captainFormKey.currentState!.validate()) _handleCaptainDeletion(); },
                                      icon: const Icon(Icons.person_remove_rounded, size: 18, color: Colors.red),
                                      label: const Text("حذف كابتن", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 3. تبويب شاشة إدارة ومتابعة إشعارات إلغاء الأوردرات للزبائن
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildSectionCard(
                            title: "تنبيهات إلغاء الأوردرات الفورية (Live)",
                            child: Column(
                              children: _cancelledOrdersFeed.map((order) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.red.shade100),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.notification_important_rounded, color: Colors.red, size: 20),
                                              const SizedBox(width: 8),
                                              Text(
                                                "قام الزبون (${order['customer']}) بإلغاء الطلب",
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 13),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            order['cancelTime'],
                                            style: TextStyle(color: navyBlue.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const Padding(padding: EdgeInsets.symmetric(vertical: 6), child: Divider(height: 1, thickness: 0.5)),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "مرحلة الإلغاء: ${order['stage']}",
                                            style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold, fontSize: 11),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: order['totalCancellations'] >= 4 ? Colors.red.shade700 : Colors.amber.shade700,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              "إجمالي إلغاءاته: ${order['totalCancellations']} أوردرات",
                                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _buildSectionCard(
                            title: "البحث في قائمة جميع المستخدمين",
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _userSearchController,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 15),
                                  decoration: _inputDecoration("ابحث بالاسم أو رقم الهاتف...", icon: Icons.search_rounded),
                                  onChanged: (value) => setState(() {}),
                                ),
                                const SizedBox(height: 16),
                                _buildUserCard("سارة عبد الرحمن", "@sara_a", "01098765432"),
                                _buildUserCard("خالد العتيبي", "@khaled_k", "01234567890"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 4. تبويب البلاغات والدعم الفني الجديد (المقروء من السابورت بالملي)
                    ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _supportTickets.length,
                      itemBuilder: (context, index) {
                        final ticket = _supportTickets[index];
                        final isDanger = ticket['style'] == "خطر";
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isDanger ? Colors.red.shade200 : Colors.grey.shade200, width: isDanger ? 1.5 : 1),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 6)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: isDanger ? Colors.red.shade50 : Colors.blue.shade50,
                                        radius: 16,
                                        child: Icon(Icons.support_agent_rounded, size: 16, color: isDanger ? Colors.red : Colors.blue),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(ticket['user']!, style: const TextStyle(fontWeight: FontWeight.w900, color: navyBlue, fontSize: 14)),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isDanger ? Colors.red.shade600 : navyBlue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(ticket['type']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                ticket['message']!,
                                style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue.withOpacity(0.7), fontSize: 13, height: 1.4),
                              ),
                              const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, thickness: 0.5)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(ticket['time']!, style: TextStyle(color: navyBlue.withOpacity(0.4), fontSize: 11, fontWeight: FontWeight.bold)),
                                  TextButton.icon(
                                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                    onPressed: () => _showSnackBar("جاري فتح الشات المباشر مع الطرفين لحل المشكلة..."),
                                    icon: const Icon(Icons.chat_rounded, size: 16, color: primaryGreen),
                                    label: const Text("تواصل وحل البلاغ", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // الكارت العادي للإحصائيات السريعة
  Widget _buildStatCard(String title, String value, IconData icon, Color mainColor, Color bgIconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgIconColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: mainColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: navyBlue.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.bold)),
                Text(value, style: const TextStyle(color: navyBlue, fontSize: 15, fontWeight: FontWeight.w900)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // كارت إحصائي متقدم يعرض التفاصيل الفرعية (مراحل الإلغاء بالملي)
  Widget _buildAdvancedStatCard({required String title, required String mainValue, required String subDetail, required IconData icon, required Color color, required Color bgColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: navyBlue.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(mainValue, style: const TextStyle(color: navyBlue, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(subDetail, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: navyBlue, fontSize: 14)),
          const Divider(thickness: 0.5, color: Color(0xFFE2E8F0), height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildUserCard(String name, String username, String phone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade100)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.white, radius: 18, child: Icon(Icons.person_outline_rounded, color: navyBlue.withOpacity(0.7), size: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 13)),
                Text("$username  •  $phone", style: TextStyle(color: navyBlue.withOpacity(0.5), fontSize: 11)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 18), onPressed: () => _showDeleteConfirmation(context, name)),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText, {required IconData icon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: navyBlue.withOpacity(0.35), fontWeight: FontWeight.w500, fontSize: 13),
      fillColor: const Color(0xFFF8FAFC),
      filled: true,
      errorStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      prefixIcon: Icon(icon, color: navyBlue.withOpacity(0.4), size: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: navyBlue, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
    );
  }
}