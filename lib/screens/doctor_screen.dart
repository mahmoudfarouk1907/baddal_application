import 'package:flutter/material.dart';
import 'payment_confirmation_screen.dart';

// الألوان الثابتة للهوية
const Color navyBlue = Color(0xFF0F172A);
final Color primaryGreen = Colors.green.shade700;

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  int selectedDoctorIndex = 0; 
  bool isOutsideCity = false;  
  int extraHours = 0;          

  final _customDoctorController = TextEditingController();
  final _customAddressController = TextEditingController();

  // متغيرات إظهار الأخطاء بصرياً
  bool _showDoctorError = false;
  bool _showAddressError = false;

  final List<Map<String, dynamic>> popularDoctors = [
    {'name': 'د. أحمد السعيد', 'specialty': 'استشاري طب الأطفال وحديثي الولادة', 'isOutside': false},
    {'name': 'د. محمد متولي', 'specialty': 'أخصائي أمراض الباطنة والقلب', 'isOutside': false},
    {'name': 'د. سارة المنشاوي', 'specialty': 'أخصائية طب وجراحة العيون', 'isOutside': false},
    {'name': 'د. محمود العراقي', 'specialty': 'استشاري جراحة العظام والكسور', 'isOutside': false},
    {'name': 'د. مصطفى رجب', 'specialty': 'أخصائي الأنف والأذن والحنجرة', 'isOutside': true}, 
    {'name': 'د. رانيا أبو النجا', 'specialty': 'استشاري أمراض النساء والتوليد', 'isOutside': false},
  ];

  int calculateWaitingPrice() {
    bool outside = selectedDoctorIndex == 6 ? isOutsideCity : popularDoctors[selectedDoctorIndex]['isOutside'];
    int firstHourPrice = outside ? 100 : 50;
    int extraHourPrice = outside ? 30 : 25;
    return firstHourPrice + (extraHours * extraHourPrice);
  }

  @override
  void dispose() {
    _customDoctorController.dispose();
    _customAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'حجز موعد طبيب (انتظار بدّال)',
          style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navyBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // التنبيه العلوي الهادي
                    _buildTopNote(),
                    const SizedBox(height: 20),

                    const Text(
                      'اختر الطبيب من قائمة الأكثر شهرة:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: navyBlue),
                    ),
                    const SizedBox(height: 12),

                    // قائمة الأطباء
                    ...List.generate(popularDoctors.length, (index) {
                      final doc = popularDoctors[index];
                      return _buildRadioDoctorCard(
                        index: index,
                        name: doc['name'],
                        specialty: doc['specialty'],
                        locationInfo: doc['isOutside'] ? 'خارج المدينة' : 'داخل المدينة',
                      );
                    }),

                    // خيار طبيب مخصص
                    _buildRadioDoctorCard(
                      index: 6,
                      name: 'طبيب آخر (كتابة بيانات مخصصة)',
                      specialty: 'إدخال يدوي لاسم الطبيب وعنوان العيادة ورسوم الخدمة',
                      locationInfo: 'حسب اختيارك',
                    ),

                    // الفورم المخصص المصلح بالكامل لمنع الـ Overflow
                    if (selectedDoctorIndex == 6) _buildCustomDoctorForm(),

                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),

                    // عداد الساعات
                    _buildHoursCounter(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // البانل السفلي الثابت
            _buildBottomBillingPanel(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueGrey.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blueGrey.shade700, size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'تنبيه: الأسعار لخدمة الانتظار فقط، وسعر كشف الطبيب يتم دفعه منفصلاً في العيادة.',
              style: TextStyle(fontSize: 12, color: navyBlue, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioDoctorCard({
    required int index,
    required String name,
    required String specialty,
    required String locationInfo,
  }) {
    bool isSelected = selectedDoctorIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? primaryGreen : Colors.grey.shade200, width: isSelected ? 1.5 : 1),
      ),
      child: RadioListTile<int>(
        value: index,
        groupValue: selectedDoctorIndex,
        activeColor: primaryGreen,
        onChanged: (val) {
          setState(() {
            selectedDoctorIndex = val!;
            _showDoctorError = false;
            _showAddressError = false;
          });
        },
        title: Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: navyBlue)),
        subtitle: Text('$specialty ($locationInfo)', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ),
    );
  }

  Widget _buildCustomDoctorForm() {
    bool hasAnyError = _showDoctorError || _showAddressError;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: hasAnyError ? Colors.red.shade300 : Colors.grey.shade200, width: hasAnyError ? 1.5 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(_customDoctorController, "اسم الطبيب والتخصص", Icons.person_outline, _showDoctorError, "يرجى كتابة اسم الطبيب"),
          const SizedBox(height: 16),
          _buildTextField(_customAddressController, "عنوان العيادة بالتفصيل", Icons.location_on_outlined, _showAddressError, "يرجى تحديد العنوان"),
          const SizedBox(height: 16),
          
          const Text('نطاق العيادة:', style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 14)),
          const SizedBox(height: 10),
          
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => isOutsideCity = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: !isOutsideCity ? primaryGreen : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: !isOutsideCity ? primaryGreen : Colors.grey.shade300),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'داخل المدينة',
                      style: TextStyle(color: !isOutsideCity ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  onTap: () => setState(() => isOutsideCity = true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isOutsideCity ? primaryGreen : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isOutsideCity ? primaryGreen : Colors.grey.shade300),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'خارج المدينة',
                      style: TextStyle(color: isOutsideCity ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, bool hasError, String errorText) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: navyBlue, 
        fontSize: 15, 
        fontWeight: FontWeight.w600, // خط داكن واضح جداً للكتابة
      ),
      onChanged: (text) {
        if (text.isNotEmpty) {
          setState(() {
            if (controller == _customDoctorController) _showDoctorError = false;
            if (controller == _customAddressController) _showAddressError = false;
          });
        }
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: hasError ? Colors.red.shade700 : navyBlue.withOpacity(0.7), 
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: TextStyle(
          color: hasError ? Colors.red.shade700 : primaryGreen,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(icon, color: hasError ? Colors.red : primaryGreen, size: 22),
        errorText: hasError ? errorText : null,
        errorStyle: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold, fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: hasError ? Colors.red : Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: hasError ? Colors.red : primaryGreen, width: 2)),
      ),
    );
  }

  Widget _buildHoursCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('مدة الانتظار الإضافية المطلوبة:', style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 14)),
            Text('الساعة الأولى مشمولة أساسياً في الخدمة', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () { if (extraHours > 0) setState(() => extraHours--); },
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            ),
            Text('$extraHours ساعة', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: navyBlue)),
            IconButton(
              onPressed: () => setState(() => extraHours++),
              icon: Icon(Icons.add_circle_outline, color: primaryGreen),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBillingPanel(BuildContext context) {
    int finalPrice = calculateWaitingPrice();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('إجمالي خدمة الانتظار المتوقعة:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: navyBlue)),
                Text('$finalPrice ج.م', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (selectedDoctorIndex == 6) {
                    setState(() {
                      _showDoctorError = _customDoctorController.text.isEmpty;
                      _showAddressError = _customAddressController.text.isEmpty;
                    });
                    if (_showDoctorError || _showAddressError) return;
                  }

                  String docName = selectedDoctorIndex == 6 
                      ? _customDoctorController.text 
                      : popularDoctors[selectedDoctorIndex]['name'];

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentConfirmationScreen(
                        totalAmount: finalPrice,
                        method: "vodafone",
                        serviceName: "انتظار دور عيادة: $docName",
                      ),
                    ),
                  );
                },
                child: const Text('تأكيد وحجز خدمة الانتظار', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}