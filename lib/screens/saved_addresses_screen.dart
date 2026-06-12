// lib/screens/saved_addresses_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);

  // لستة العناوين الافتراضية في حال أول مرة يفتح الأبلكيشن ولم يسجل أي شيء
  List<String> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  // 🔄 جلب العناوين المحفوظة من الكاش
  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    // بنجيب اللستة، لو ملهاش وجود بنحط عنوان افتراضي (المنزل الافتراضي بتاعك) عشان نضمن وجود عنوان دايماً
    List<String>? savedList = prefs.getStringList('saved_user_addresses');
    if (savedList == null || savedList.isEmpty) {
      savedList = ["المنزل|شارع الجمهورية، بجوار مركز الشرطة، أجا، الدقهلية"];
      await prefs.setStringList('saved_user_addresses', savedList);
    }
    setState(() {
      _addresses = savedList!;
      _isLoading = false;
    });
  }

  // 💾 حفظ التعديلات الجديدة في الكاش
  Future<void> _saveAddressesToCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_user_addresses', _addresses);
  }

  // ➕ دالة إضافة عنوان جديد
  void _addNewAddress(String type, String details) {
    if (details.trim().isEmpty) return;
    setState(() {
      // بنفصل النوع عن التفاصيل بعلامة | عشان نعرف نقسمهم وقت العرض بسهولة
      _addresses.add("$type|${details.trim()}");
    });
    _saveAddressesToCache();
    Navigator.pop(context); // إغلاق الـ Bottom Sheet
    _showCustomSnackBar("عملية ناجحة", "تم إضافة العنوان الجديد بنجاح.", primaryGreen);
  }

  // 🗑️ دالة حذف عنوان مع تطبيق شرط الأمان
  void _deleteAddress(int index) {
    if (_addresses.length <= 1) {
      _showCustomSnackBar("تنبيه أمني", "لا يمكن حذف العنوان. يجب أن تحتفظ بعنوان واحد على الأقل لتوصيل الطلبات.", Colors.orange);
      return;
    }
    setState(() {
      _addresses.removeAt(index);
    });
    _saveAddressesToCache();
    _showCustomSnackBar("عملية ناجحة", "تم حذف العنوان بنجاح.", Colors.redAccent);
  }

  // 🛠️ ميثود لتحديد أيقونة العنوان بناءً على النوع الكاش
  IconData _getIconForType(String type) {
    switch (type) {
      case "المنزل":
        return Icons.home_rounded;
      case "العمل":
        return Icons.business_center_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  // 📥 فتح شاشة إضافة عنوان (BottomSheet سفلي احترافي)
  void _showAddAddressBottomSheet() {
    String selectedType = "المنزل";
    final TextEditingController detailsController = TextEditingController();
    final formKey = GlobalKey<FormState>();

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
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24, // متجاوب مع ظهور الكيبورد
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(color: Colors.grey, borderRadius: const BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "إضافة عنوان جديد",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: navyBlue),
                      ),
                      const SizedBox(height: 20),
                      const Text("نوع العنوان", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 14)),
                      const SizedBox(height: 10),
                      
                      // أزرار اختيار نوع العنوان كبسولات (المنزل / العمل / أخرى)
                      Row(
                        children: ["المنزل", "العمل", "أخرى"].map((type) {
                          bool isSelected = selectedType == type;
                          return Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: ChoiceChip(
                              label: Text(type, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : navyBlue)),
                              selected: isSelected,
                              selectedColor: primaryGreen,
                              backgroundColor: Colors.grey.shade100,
                              checkmarkColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              onSelected: (bool selected) {
                                if (selected) {
                                  setModalState(() => selectedType = type);
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      const Text("تفاصيل العنوان بالكامل", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 14)),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: detailsController,
                        maxLines: 2,
                        validator: (v) => (v == null || v.trim().isEmpty) ? "برجاء كتابة تفاصيل العنوان" : null,
                        style: const TextStyle(fontWeight: FontWeight.w600, color: navyBlue, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "اسم الشارع، رقم العقار، المعالم البارزة...",
                          hintStyle: TextStyle(color: navyBlue.withValues(alpha: 0.4)),
                          fillColor: const Color(0xFFF8FAFC),
                          filled: true,
                          errorStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryGreen, width: 2)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: navyBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              _addNewAddress(selectedType, detailsController.text);
                            }
                          },
                          child: const Text("حفظ العنوان الجديد", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ميثود موحدة لعرض التنبيهات والـ SnackBars الاحترافية الخاصة بك
  void _showCustomSnackBar(String title, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(title == "عملية ناجحة" ? Icons.check_circle_rounded : Icons.warning_rounded, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 14)),
                  Text(message, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xE6FFFFFF), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // تحديد لون زر الحذف بناءً على حماية الشرط (لو عنوان وحيد يقفل الحذف بصرياً)
    bool isDeletionRestricted = _addresses.length <= 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("العناوين المحفوظة", style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 18)),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: primaryGreen))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _addresses.length,
                        itemBuilder: (context, index) {
                          // تقسيم النص المحفوظ لاستخراج النوع لوحده والتفاصيل لوحدها
                          List<String> parts = _addresses[index].split('|');
                          String type = parts[0];
                          String details = parts.length > 1 ? parts[1] : '';

                          return Card(
                            color: Colors.white,
                            elevation: 0,
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                                side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFFDCFCE7),
                                child: Icon(_getIconForType(type), color: primaryGreen),
                              ),
                              title: Text(type, style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 15)),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(details, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4, fontWeight: FontWeight.w500)),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  color: isDeletionRestricted ? Colors.grey.shade300 : Colors.redAccent,
                                ),
                                onPressed: () => _deleteAddress(index),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // زر إضافة عنوان جديد
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navyBlue,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        onPressed: _showAddAddressBottomSheet,
                        icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
                        label: const Text("إضافة عنوان جديد", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}