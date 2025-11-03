import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../utils/validators.dart';
import '../widgets/input_field.dart';
import '../widgets/rounded_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: controller.signInFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/bulb_1.png', height: 70,width: 70,),
                const SizedBox(height: 20),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please login first to start your Theory Test.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                InputField(
                  label: "Email Address",
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                ),
                const SizedBox(height: 20),
                Obx(() => InputField(
                      label: "Password",
                      controller: controller.passwordController,
                      obscure: !controller.passwordVisible.value,
                      validator: Validators.password,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {
    // ✅ Pressing enter triggers sign in
                         controller.signIn();
  },
                      suffix: IconButton(
                        icon: Icon(
                          controller.passwordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    )),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Row(
                          children: [
                            Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (_) => controller.toggleRememberMe(),
                            ),
                            const Text("Remember Me"),
                          ],
                        )),
                    TextButton(
                      onPressed: () {
                         Get.toNamed('/forgot');
                      },
                      child: const Text("Forgot Password"),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Obx(() => RoundedButton(
                      label: "Sign In",
                      loading: controller.isSigningIn.value,
                      onPressed: controller.signIn,
                    )),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("New to Theory Test? "),
                    GestureDetector(
                      onTap: () => Get.toNamed('/signup'),
                      child: const Text(
                        "Create Account",
                        style: TextStyle(color: Color(0xFF2979FF)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
