import 'package:flutter/material.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  static const Color navyBlue = Color(0xFF0F172A);
  static const Color primaryGreen = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("العناوين المحفوظة", style: TextStyle(color: navyBlue, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: navyBlue), onPressed: () => Navigator.pop(context)),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // العنوان الحالي
              Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.grey.shade200)),
                child: ListTile(
                  leading: const CircleAvatar(backgroundColor: Color(0xFFDCFCE7), child: Icon(Icons.home_rounded, color: primaryGreen)),
                  title: const Text("المنزل (أجا)", style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue)),
                  subtitle: const Text("شارع الجمهورية، بجوار مركز الشرطة، أجا، الدقهلية", style: TextStyle(fontSize: 13)),
                  trailing: IconButton(icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent), onPressed: () {}),
                ),
              ),
              const Spacer(),
              // زر إضافة عنوان جديد
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: navyBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ميزة إضافة عنوان جديد ستتوفر قريباً"))),
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