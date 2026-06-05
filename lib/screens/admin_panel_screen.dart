import 'package:flutter/material.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color backgroundColor = Color(0xFFF8FAFC);

  // المتحكمات
  final _captainNameController = TextEditingController();
  final _captainPhoneController = TextEditingController();
  final _captainVehicleController = TextEditingController();
  final _broadcastController = TextEditingController();
  final _userSearchController = TextEditingController();

  final _captainFormKey = GlobalKey<FormState>();
  final _broadcastFormKey = GlobalKey<FormState>();

  // 1. قائمة كباتن وهمية (Mock Data) لاختبار السيناريوهات الذكية التي طلبتها
  final List<Map<String, String>> _mockCaptains = [
    {"name": "كابتن مصطفى نصر", "phone": "01012345678", "vehicle": "موتوسيكل دايون"},
    {"name": "كابتن محمد علي", "phone": "01288889999", "vehicle": "عجلة ترينكس"},
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

  // ميثود ذكي للتحقق والحذف بناءً على طلبك
  void _handleCaptainDeletion() {
    final nameInput = _captainNameController.text.trim();
    final phoneInput = _captainPhoneController.text.trim();

    // البحث عن الكابتن برقم الهاتف في القائمة
    final existingCaptain = _mockCaptains.firstWhere(
      (c) => c["phone"] == phoneInput,
      orElse: () => {},
    );

    if (existingCaptain.isEmpty) {
      // السيناريو 1: الرقم مش موجود في السيستم أصلاً
      _showSnackBar("عذراً، لا يوجد كابتن مسجل بهذا الرقم في النظام", isError: true);
    } else if (existingCaptain["name"] != nameInput) {
      // السيناريو 2: الرقم موجود بس الاسم اللي الأدمن كتبه غلط
      final actualName = existingCaptain["name"];
      _showSnackBar(
        "الاسم خاطئ! ولكن يوجد كابتن باسم ($actualName) يمتلك نفس رقم الهاتف", 
        isError: true
      );
    } else {
      // السيناريو 3: الاسم والرقم متطابقين (حذف ناجح)
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.delete_forever_rounded, color: Colors.red.shade600, size: 40),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "تأكيد حذف الحساب",
                    style: TextStyle(fontWeight: FontWeight.w900, color: navyBlue, fontSize: 18),
                  ),
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            Expanded(
              child: Text(
                message, 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                maxLines: 2,
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red.shade600 : primaryGreen,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "لوحة تحكم المسؤول",
          style: TextStyle(color: navyBlue, fontWeight: FontWeight.w800, fontSize: 19),
        ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- كروت الإحصائيات ---
              Row(
                children: [
                  Expanded(child: _buildStatCard("إجمالي الرحلات", "${1284 + _mockCaptains.length}", Icons.trending_up_rounded, primaryGreen)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard("الكباتن النشطين", "${_mockCaptains.length}", Icons.directions_bike_rounded, navyBlue)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildStatCard("بلاغات قيد المعالجة", "7", Icons.warning_amber_rounded, Colors.red)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard("حجوزات الأطباء", "18", Icons.medical_services, Colors.blue)),
                ],
              ),
              const SizedBox(height: 24),

              // --- بث إشعار عالمي ---
              Form(
                key: _broadcastFormKey,
                child: _buildSectionCard(
                  title: "بث إشعار عالمي",
                  icon: Icons.campaign_rounded,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _broadcastController,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 14),
                          validator: (v) => (v == null || v.trim().isEmpty) ? "محتوى الإشعار فارغ!" : null,
                          decoration: _inputDecoration("اكتب تحديثاً ليتم نشره لجميع المنصة...", isSearch: false),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (_broadcastFormKey.currentState!.validate()) {
                            _showSnackBar("تم بث الإشعار لكل مستخدمي تطبيق بدال بنجاح");
                            _broadcastController.clear();
                          }
                        },
                        child: const Text("نشر", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- إدارة الكباتن ---
              Form(
                key: _captainFormKey,
                child: _buildSectionCard(
                  title: "إدارة الكباتن",
                  icon: Icons.sports_motorsports_rounded,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("الاسم الكامل", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 14)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _captainNameController,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 15),
                        validator: (v) => (v == null || v.trim().isEmpty) ? "اسم الكابتن مطلوب للإجراء" : null,
                        decoration: _inputDecoration("مثال: أحمد محمد", isSearch: false),
                      ),
                      const SizedBox(height: 14),
                      const Text("رقم الهاتف", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 14)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _captainPhoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 15),
                        // 2. فالديشن مصري ذكي ومحكم للرقم بالكامل
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "رقم الهاتف مطلوب";
                          final regExp = RegExp(r'^01[0125][0-9]{8}$');
                          if (!regExp.hasMatch(v.trim())) {
                            return "أدخل رقم مصري صحيح مكون من 11 رقم (010, 011, 012, 015)";
                          }
                          return null;
                        },
                        decoration: _inputDecoration("01xxxxxxxxx", isSearch: false),
                      ),
                      const SizedBox(height: 14),
                      const Text("نوع المركبة", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 14)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _captainVehicleController,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 15),
                        validator: (v) {
                          // نوع المركبة مطلوب فقط عند الإضافة وليس الحذف
                          return null; 
                        },
                        decoration: _inputDecoration("عجلة اقتصادية / موتوسيكل (مطلوب للإضافة فقط)", isSearch: false),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreen,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
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
                                  _showSnackBar("تم تسجيل الكابتن الجديد في السيستم بنجاح");
                                  _captainNameController.clear();
                                  _captainPhoneController.clear();
                                  _captainVehicleController.clear();
                                }
                              },
                              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18, color: Colors.white),
                              label: const Text("إضافة كابتن", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.red, width: 1.5),
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () {
                                // تشغيل الفالديشن أولاً للتأكد من صحة شكل الرقم والاسم
                                if (_captainFormKey.currentState!.validate()) {
                                  _handleCaptainDeletion();
                                }
                              },
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
              const SizedBox(height: 24),

              // --- إدارة المستخدمين ---
              _buildSectionCard(
                title: "إدارة المستخدمين",
                icon: Icons.people_alt_rounded,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _userSearchController,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 15),
                      decoration: _inputDecoration("ابحث عن مستخدم بالاسم أو رقم الهاتف...", isSearch: true),
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    _buildUserListTile("سارة عبد الرحمن", "@sara_a", "01098765432"),
                    const Divider(height: 20, thickness: 0.5),
                    _buildUserListTile("خالد العتيبي", "@khaled_k", "01234567890"),
                    const Divider(height: 20, thickness: 0.5),
                    _buildUserListTile("إيلاف منصور", "@elaf_m", "01511223344"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            radius: 22,
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: navyBlue.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: navyBlue, fontSize: 18, fontWeight: FontWeight.w900)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryGreen, size: 24),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: navyBlue, fontSize: 17)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(thickness: 0.8, color: Color(0xFFE2E8F0)),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildUserListTile(String name, String username, String phone) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          child: const Icon(Icons.person_outline_rounded, color: navyBlue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 15)),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(username, style: TextStyle(color: navyBlue.withOpacity(0.5), fontSize: 12)),
                  const SizedBox(width: 8),
                  Text("•  $phone", style: TextStyle(color: navyBlue.withOpacity(0.4), fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: primaryGreen, size: 20),
          onPressed: () => _showSnackBar("تعديل بيانات المستخدم متاح فور ربط الـ API"),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
          onPressed: () => _showDeleteConfirmation(context, name),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hintText, {required bool isSearch}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: navyBlue.withOpacity(0.35), fontWeight: FontWeight.w500, fontSize: 14),
      fillColor: const Color(0xFFF8FAFC),
      filled: true,
      errorStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      prefixIcon: isSearch ? const Icon(Icons.search_rounded, color: primaryGreen, size: 22) : null,
      suffixIcon: isSearch && _userSearchController.text.isNotEmpty 
          ? IconButton(
              icon: const Icon(Icons.clear_rounded, color: Colors.grey, size: 18),
              onPressed: () {
                setState(() {
                  _userSearchController.clear();
                });
              },
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}