import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../utils/validators.dart';
import '../widgets/input_field.dart';
import '../widgets/rounded_button.dart';
import 'successful_popup.dart'; // ✅ Import popup widget

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    // Local observables for password visibility
    final newPasswordVisible = false.obs;
    final confirmPasswordVisible = false.obs;

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 40, color: Colors.black),
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
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Reset Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your password must be at least 8 characters long and include a combination of letters and numbers.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 30),

              // 🔒 New Password Field
              Obx(() => InputField(
                    label: "New Password",
                    controller: controller.newPasswordController,
                    obscure: !newPasswordVisible.value,
                    validator: Validators.password,
                    textInputAction: TextInputAction.next,
                    suffix: IconButton(
                      icon: Icon(
                        newPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () => newPasswordVisible.value =
                          !newPasswordVisible.value,
                    ),
                  )),
              const SizedBox(height: 20),

              // 🔒 Confirm Password Field
              Obx(() => InputField(
                    label: "Confirm Password",
                    controller: controller.confirmPasswordController,
                    obscure: !confirmPasswordVisible.value,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (value != controller.newPasswordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    suffix: IconButton(
                      icon: Icon(
                        confirmPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () => confirmPasswordVisible.value =
                          !confirmPasswordVisible.value,
                    ),
                  )),

              const SizedBox(height: 40),

              // ✅ Submit Button
              RoundedButton(
                label: "Submit",
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // ✅ Show popup dialog instead of navigating
                    Get.dialog(
                      const SuccessfulPopup(),
                      barrierDismissible: false, // prevent closing manually
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
