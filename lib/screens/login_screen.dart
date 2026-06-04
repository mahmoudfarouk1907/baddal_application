import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup_screen.dart';
import 'otp_screen.dart'; // استدعاء شاشة الـ OTP الجديدة

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // دالة التحقق من رقم الهاتف المصري
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }
    // التأكد إن الرقم 11 خانة وبيبدأ بأرقام شبكات مصر المعروفة
    final regExp = RegExp(r'^01[0125][0-9]{8}$');
    if (!regExp.hasMatch(value)) {
      return 'رقم هاتف مصري غير صحيح (يجب أن يبدأ بـ 010, 011, 012, 015)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF22C55E);
    const navyBlue = Color(0xFF0F172A);
    final textHighContrast = navyBlue.withOpacity(0.7);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey, // ربط الحقول بالفورم للتحقق
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'baddal',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: primaryGreen),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'تسجيل الدخول', 
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: navyBlue)
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'مرحباً بك مجدداً في baddal', 
                    style: TextStyle(color: textHighContrast, fontSize: 15, fontWeight: FontWeight.w500)
                  ),
                  const SizedBox(height: 35),

                  // حقل البريد الإلكتروني
                  _buildFieldLabel('البريد الإلكتروني أو اسم المستخدم'),
                  TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: navyBlue, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                    decoration: _buildInputDecoration(Icons.email_outlined, 'example@baddal.com', navyBlue),
                  ),
                  const SizedBox(height: 20),

                  // حقل كلمة المرور
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFieldLabel('كلمة المرور'),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'نسيت كلمة المرور؟', 
                          style: TextStyle(color: primaryGreen, fontSize: 13, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(color: navyBlue, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.right,
                    decoration: _buildInputDecoration(Icons.visibility_outlined, '••••••••', navyBlue),
                  ),
                  
                  const SizedBox(height: 25),
                  Text(
                    'أو عبر رقم الهاتف المصري', 
                    style: TextStyle(color: textHighContrast, fontSize: 14, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 15),

                  // حقل رقم الهاتف المضبط بـ Validation
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.arrow_drop_down, color: navyBlue),
                            SizedBox(width: 4),
                            Text('EG +20', style: TextStyle(fontWeight: FontWeight.bold, color: navyBlue, fontSize: 15)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 11,
                          validator: _validatePhoneNumber, // تفعيل الفحص هنا
                          style: const TextStyle(color: navyBlue, fontWeight: FontWeight.w600, fontSize: 17, letterSpacing: 1.2),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: _buildInputDecoration(null, '01x xxxx xxxx', navyBlue).copyWith(
                            counterText: "",
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),
                  // زر دخول المربوط بالـ Validation والـ OTP
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // التحقق من الفورم أولاً قبل الدخول
                        if (_formKey.currentState!.validate()) {
                          // تحديد وسيلة الدفع أو الإرسال بناءً على المدخلات لنقلها لصفحة الـ OTP
                          String targetDestination = _phoneController.text.isNotEmpty 
                              ? _phoneController.text 
                              : _emailController.text;

                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => OtpScreen(destination: targetDestination)
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('دخول', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 30),
                  Text('تسجيل سريع عبر', style: TextStyle(color: textHighContrast, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Expanded(child: _buildSocialButton('Google', Icons.g_mobiledata_rounded, navyBlue)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildSocialButton('Apple', Icons.apple, navyBlue)),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ليس لديك حساب؟ ', style: TextStyle(color: textHighContrast, fontWeight: FontWeight.w500)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                        },
                        child: const Text('إنشاء حساب جديد', style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
      ),
    );
  }

  InputDecoration _buildInputDecoration(IconData? prefixIcon, String hint, Color navy) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: navy.withOpacity(0.4), fontSize: 14, fontWeight: FontWeight.w400),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: navy.withOpacity(0.6)) : null,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      errorStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[400]!, width: 1.2)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF22C55E), width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1.2)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 2)),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, Color navy) {
    return Container(
      height: 52,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[300]!, width: 1.2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28, color: navy),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: navy, fontSize: 15)),
        ],
      ),
    );
  }
}