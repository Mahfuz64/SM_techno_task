import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../widgets/rounded_button.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final controller = Get.find<AuthController>();

  static const int otpFieldCount = 4;
  late List<TextEditingController> _codeControllers;
  late List<FocusNode> _focusNodes;

  // 🔹 Timer variables
  Timer? _timer;
  int _secondsRemaining = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _codeControllers = List.generate(otpFieldCount, (_) => TextEditingController());
    _focusNodes = List.generate(otpFieldCount, (_) => FocusNode());
    _startTimer(); // Start timer immediately on page load
  }

  @override
  void dispose() {
    for (var c in _codeControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  // 🔹 Handle focus changes for OTP
  void _handleCodeChange(String value, int index) {
    if (value.isNotEmpty && index < otpFieldCount - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  // 🔹 Start / Restart Timer
  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  // 🔹 Validate OTP and navigate to reset page
  void _validateAndProceed() {
    String fullCode = _codeControllers.map((c) => c.text).join();
    if (fullCode.length < otpFieldCount) {
      Get.snackbar('Invalid Code', 'Please enter all 4 digits of the code.',
          backgroundColor: Colors.redAccent.withOpacity(0.2),
          colorText: Colors.red);
      return;
    }

    // ✅ Go to Reset Password
    Get.toNamed('/reset');
  }

  @override
  Widget build(BuildContext context) {
    const String dummyEmail = "pristia@gmail.com";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 24, color: Colors.black),
           onPressed: () { final controller = Get.find<AuthController>();
  controller.emailController.clear();
  controller.passwordController.clear();
  controller.confirmPasswordController.clear();
  
  Get.back();}
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Verify Code",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 12),
            Text(
              "Please enter the code we just sent to\nemail ${controller.emailController.text.isEmpty ? dummyEmail : controller.emailController.text}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.blueGrey[600]),
            ),
            const SizedBox(height: 50),

            // 🔢 OTP Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                otpFieldCount,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: TextField(
                      controller: _codeControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      onChanged: (v) => _handleCodeChange(v, index),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 🔁 Resend Option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _canResend
                      ? "Didn’t receive code?"
                      : "Resend available in $_secondsRemaining s",
                  style: const TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: _canResend
                      ? () {
                          // Simulate resend OTP logic
                          Get.snackbar(
                            "Code Sent",
                            "A new verification code has been sent to your email.",
                            backgroundColor: Colors.greenAccent.withOpacity(0.2),
                            colorText: Colors.green,
                          );
                          _startTimer(); // restart timer
                        }
                      : null,
                  child: Text(
                    "Resend",
                    style: TextStyle(
                      color: _canResend ? Theme.of(context).primaryColor : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // ✅ Continue Button
            RoundedButton(
              label: "Continue",
              onPressed: _validateAndProceed,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
