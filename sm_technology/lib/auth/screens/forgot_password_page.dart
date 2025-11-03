import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../utils/validators.dart';
import '../widgets/input_field.dart';
import '../widgets/rounded_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final formKey = GlobalKey<FormState>(); // ✅ Local form key for validation

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 40),
         onPressed: () { final controller = Get.find<AuthController>();
  controller.emailController.clear();
  controller.passwordController.clear();
  controller.confirmPasswordController.clear();
  
  Get.back();},
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey, // ✅ Wrap form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Forgot Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter your email, we will send a verification code to your email.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              InputField(
                label: "Email Address",
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                
                validator: Validators.email,
              ),
              const SizedBox(height: 40),
              RoundedButton(
                label: "Continue",
                onPressed: () {
                  // ✅ Validate before navigating
                  if (formKey.currentState?.validate() ?? false) {
                    controller.sendResetCode(); // optional: logic to send OTP
                    Get.toNamed('/verify');
                  } else {
                    Get.snackbar(
                      "Invalid Email",
                      "Please enter a valid email address",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
