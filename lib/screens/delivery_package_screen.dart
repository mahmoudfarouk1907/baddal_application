import 'package:flutter/material.dart';
import 'payment_confirmation_screen.dart';

class DeliveryPackageScreen extends StatefulWidget {
  const DeliveryPackageScreen({super.key});

  @override
  State<DeliveryPackageScreen> createState() => _DeliveryPackageScreenState();
}

class _DeliveryPackageScreenState extends State<DeliveryPackageScreen> {
  int selectedOption = 0; // 0: داخل المدينة، 1: خارج المدينة
  int get price => selectedOption == 0 ? 25 : 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("توصيل طرد", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("بيانات الطرد", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "اكتب وصف الطرد (مثلاً: أوراق مهمة، ملابس، أمانة)...",
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            
            // اختيار المسافة
            Container(
              decoration: BoxDecoration(
                color: Colors.green.shade50.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
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
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentConfirmationScreen(
                        totalAmount: price,
                        method: "vodafone",
                        serviceName: "توصيل طرد",
                      ),
                    ),
                  );
                },
                child: Text("تأكيد الطلب - $price جنيه", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}