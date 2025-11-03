import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../utils/validators.dart';
import '../widgets/input_field.dart';
import '../widgets/rounded_button.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 40, color: Colors.black),
          onPressed: () { final controller = Get.find<AuthController>();
  controller.emailController.clear();
  controller.passwordController.clear();
  
  Get.back();},
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Form(
                key: controller.signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/bulb_1.png', height: 70, width: 70),
                    const SizedBox(height: 20),
                    const Text(
                      "Create Account",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Please fill the details to register your account.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Full Name
                    InputField(
                      label: "Full Name",
                      controller: controller.signUpNameController,
                      keyboardType: TextInputType.name,
                      validator: Validators.name,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),

                    // Email
                    InputField(
                      label: "Email Address",
                      controller: controller.signUpEmailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),

                    // Password with strength indicator
                    Obx(() {
                      final password = controller.signUpPasswordController.text;
                      final strength = Validators.passwordStrength(password);
                      final strengthColor = Validators.passwordStrengthColor(strength);
                      final strengthText = Validators.passwordStrengthText(strength);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InputField(
                            label: "Password",
                            controller: controller.signUpPasswordController,
                            obscure: !controller.signUpPasswordVisible.value,
                            validator: Validators.password,
                            textInputAction: TextInputAction.done,
                            onChanged: (_) => controller.update(),
                            suffix: IconButton(
                              icon: Icon(
                                controller.signUpPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: controller.toggleSignUpPasswordVisibility,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: strengthColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                strengthText,
                                style: TextStyle(
                                  color: strengthColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 40),

                    // Sign Up Button
                    Obx(() => RoundedButton(
                          label: "Sign Up",
                          loading: controller.isSigningUp.value,
                          onPressed: () async {
                            await controller.signUp();
                            if (!(controller.signUpFormKey.currentState?.validate() ?? false)) return;
                          },
                        )),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () => Get.toNamed('/signin'),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(color: Color(0xFF2979FF)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
