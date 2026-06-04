import 'package:flutter/material.dart';
import 'payment_confirmation_screen.dart';

class CaptainRideScreen extends StatefulWidget {
  const CaptainRideScreen({super.key});

  @override
  State<CaptainRideScreen> createState() => _CaptainRideScreenState();
}

class _CaptainRideScreenState extends State<CaptainRideScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  
  int selectedOption = 0; 
  int get price => selectedOption == 0 ? 25 : 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("طلب كابتن مشاوير", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
              child: Column(
                children: [
                  _buildTextField(_fromController, "مكان الاستلام", Icons.location_on_outlined),
                  const SizedBox(height: 16),
                  _buildTextField(_toController, "مكان التوصيل", Icons.flag_outlined),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // اختيار المسافة بدون خطوط فاصلة
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  RadioListTile(
                    activeColor: Colors.green.shade700,
                    title: const Text("داخل المدينة (25 جنيه)"),
                    value: 0,
                    groupValue: selectedOption,
                    onChanged: (val) => setState(() => selectedOption = val!),
                  ),
                  RadioListTile(
                    activeColor: Colors.green.shade700,
                    title: const Text("خارج المدينة (40 جنيه)"),
                    value: 1,
                    groupValue: selectedOption,
                    onChanged: (val) => setState(() => selectedOption = val!),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentConfirmationScreen(
                        totalAmount: price,
                        method: "vodafone",
                        serviceName: "طلب كابتن",
                      ),
                    ),
                  );
                },
                child: Text("تأكيد الطلب ($price ج.م)", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green.shade600),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.green.shade700, width: 2)),
      ),
    );
  }
}