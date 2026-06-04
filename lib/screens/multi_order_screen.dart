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

  bool isOutsideCity = false;
  String selectedPaymentMethod = "vodafone";

  int calculateTotalPrice() {
    int basePrice = isOutsideCity ? 40 : 25;
    int extraStopsCount = _stopControllers.length > 1 ? _stopControllers.length - 1 : 0;
    return basePrice + (extraStopsCount * 7);
  }

  void _addStop() => setState(() => _stopControllers.add({"place": TextEditingController(), "task": TextEditingController()}));

  void _removeStop(int index) {
    setState(() {
      _stopControllers[index]['place']?.dispose();
      _stopControllers[index]['task']?.dispose();
      _stopControllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("مشوار بدّال الحر", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Column(
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
    );
  }

  Widget _buildZoneSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          _buildZoneOption("داخل المدينة", false, 25),
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: isSelected ? Colors.green.shade700 : Colors.transparent, borderRadius: BorderRadius.circular(8)),
          child: Text("$title ($price ج)", textAlign: TextAlign.center, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildStopCard(int index) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(index == 0 ? "نقطة البداية" : "محطة ${index}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700)),
                if (index > 0) IconButton(icon: const Icon(Icons.close, color: Colors.red, size: 18), onPressed: () => _removeStop(index)),
              ],
            ),
            const SizedBox(height: 10),
            TextField(controller: _stopControllers[index]['place'], decoration: InputDecoration(labelText: "العنوان", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 10),
            TextField(controller: _stopControllers[index]['task'], decoration: InputDecoration(labelText: "المطلوب", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: _addStop,
            icon: const Icon(Icons.add),
            label: const Text("إضافة محطة أخرى (+7 ج)"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade100, foregroundColor: Colors.green.shade700, elevation: 0),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("الإجمالي:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("${calculateTotalPrice()} جنيه", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () {
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
              },
              child: const Text("تأكيد وحجز المشوار", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}