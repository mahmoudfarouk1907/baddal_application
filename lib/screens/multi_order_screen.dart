import 'package:flutter/material.dart';
import 'payment_confirmation_screen.dart';

class MultiOrderScreen extends StatefulWidget {
  const MultiOrderScreen({super.key});

  @override
  State<MultiOrderScreen> createState() => _MultiOrderScreenState();
}

class _MultiOrderScreenState extends State<MultiOrderScreen> {
  final List<Map<String, TextEditingController>> _stopControllers = [
    {
      "place": TextEditingController(),
      "task": TextEditingController(),
    }
  ];

  final _formKey = GlobalKey<FormState>(); // مفتاح الفحص لكل المحطات ديناميكياً
  bool isOutsideCity = false;
  String selectedPaymentMethod = "vodafone";

  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);

  int calculateTotalPrice() {
    int basePrice = isOutsideCity ? 40 : 25;
    int extraStopsCount = _stopControllers.length > 1 ? _stopControllers.length - 1 : 0;
    return basePrice + (extraStopsCount * 7);
  }

  void _addStop() {
    setState(() {
      _stopControllers.add({
        "place": TextEditingController(),
        "task": TextEditingController(),
      });
    });
  }

  void _removeStop(int index) {
    setState(() {
      _stopControllers[index]['place']?.dispose();
      _stopControllers[index]['task']?.dispose();
      _stopControllers.removeAt(index);
    });
  }

  void _submitOrder() {
    // الفحص الذكي: لو كل العناوين والمطلوب في كل المحطات مليانة هيعدي
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentConfirmationScreen(
            totalAmount: calculateTotalPrice(),
            method: selectedPaymentMethod,
            serviceName: "مشوار بدّال الحر",
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    for (var stop in _stopControllers) {
      stop['place']?.dispose();
      stop['task']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("مشوار بدّال الحر", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl, // ضبط الواجهة كاملة للعربي
        child: Form(
          key: _formKey, // ربط حقول المحطات كلها بالـ Form الرئيسي
          child: Column(
            children: [
              _buildZoneSelector(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _stopControllers.length,
                  itemBuilder: (context, index) => _buildStopCard(index),
                ),
              ),
              _buildBottomPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZoneSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
      ),
      child: Row(
        children: [
          _buildZoneOption("داخل المدينة", false, 25),
          const SizedBox(width: 6),
          _buildZoneOption("خارج المدينة", true, 40),
        ],
      ),
    );
  }

  Widget _buildZoneOption(String title, bool value, int price) {
    bool isSelected = isOutsideCity == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => isOutsideCity = value),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? primaryGreen : const Color(0xFFF1F5F9), 
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "$title ($price ج)", 
            textAlign: TextAlign.center, 
            style: TextStyle(
              color: isSelected ? Colors.white : navyBlue, 
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStopCard(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  index == 0 ? "📍 نقطة البداية" : "🛑 محطة رقم $index", 
                  style: const TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 16),
                ),
                if (index > 0) 
                  IconButton(
                    icon: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 24), 
                    onPressed: () => _removeStop(index),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            _buildTextFormField(_stopControllers[index]['place']!, "العنوان بالتفصيل", Icons.map_rounded, "برجاء كتابة عنوان المحطة"),
            const SizedBox(height: 14),
            _buildTextFormField(_stopControllers[index]['task']!, "ما المطلوب من الكابتن هناك؟", Icons.assignment_rounded, "برجاء كتابة المطلوب تنفيذه"),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), 
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, -2)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _addStop,
              icon: const Icon(Icons.add_circle_outline_rounded, color: primaryGreen, size: 22),
              label: const Text("إضافة محطة أخرى (+7 ج)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: primaryGreen)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: primaryGreen, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("إجمالي تكلفة المشوار:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: navyBlue)),
              Text("${calculateTotalPrice()} جنيه", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryGreen)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _submitOrder, // استدعاء الفحص والـ Submit
              child: const Text("تأكيد وحجز المشوار", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, IconData icon, String errorText) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontWeight: FontWeight.w600, color: navyBlue),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return errorText;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 14),
        prefixIcon: Icon(icon, color: primaryGreen),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        errorStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
        ),
      ),
    );
  }
}