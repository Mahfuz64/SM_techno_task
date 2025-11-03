// auth_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/home_page.dart';

class AuthController extends GetxController {
  // ----------------------------
  // FORM KEYS
  // ----------------------------
  final signInFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();
  final forgotPasswordFormKey = GlobalKey<FormState>();
  final verifyFormKey = GlobalKey<FormState>();
  final resetFormKey = GlobalKey<FormState>();

  // ----------------------------
  // TEXT CONTROLLERS
  // ----------------------------
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign up
  final signUpNameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();

  // Forgot / Reset flow
  final forgotEmailController = TextEditingController(); // step1
  final otpController = TextEditingController(); // step2 (6-digit)
  final newPasswordController = TextEditingController(); // step3
  final confirmPasswordController = TextEditingController(); // step3

  // ----------------------------
  // STATE (reactive)
  // ----------------------------
  final rememberMe = false.obs;
  final passwordVisible = false.obs;
  final signUpPasswordVisible = false.obs;

  // Loading / busy states
  final isSigningIn = false.obs;
  final isSigningUp = false.obs;
  final isLoading = false.obs; // generic loading
  final isResetFlowLoading = false.obs; // optional more specific loading

  // Password strength UI
  final passwordStrength = 0.0.obs;
  final passwordLabel = ''.obs;

  // OTP / Resend logic
  final otpLength = 6; // change if you want different length
  final otpTimer = 30.obs; // countdown seconds
  final canResendOTP = false.obs;
  Timer? _otpTimer; // internal timer

  // ----------------------------
  // TOGGLES
  // ----------------------------
  void toggleRememberMe() => rememberMe.value = !rememberMe.value;
  void togglePasswordVisibility() => passwordVisible.value = !passwordVisible.value;
  void toggleSignUpPasswordVisibility() => signUpPasswordVisible.value = !signUpPasswordVisible.value;

  // ----------------------------
  // PASSWORD STRENGTH
  // ----------------------------
  void checkPasswordStrength(String value) {
    if (value.isEmpty) {
      passwordStrength.value = 0;
      passwordLabel.value = '';
      return;
    }

    double strength = 0;
    if (value.length >= 8) strength += 0.4;
    if (RegExp(r'[A-Z]').hasMatch(value)) strength += 0.2;
    if (RegExp(r'[0-9]').hasMatch(value)) strength += 0.2;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) strength += 0.2;

    passwordStrength.value = strength.clamp(0.0, 1.0);
    if (strength < 0.4) {
      passwordLabel.value = "Weak";
    } else if (strength < 0.7) {
      passwordLabel.value = "Medium";
    } else {
      passwordLabel.value = "Strong";
    }
  }

  // ----------------------------
  // SIGN IN / SIGN UP (examples)
  // ----------------------------
  Future<void> signIn() async {
    if (!(signInFormKey.currentState?.validate() ?? false)) return;
    isSigningIn.value = true;
    try {
      // perform sign-in network call here
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed('/enable_location');
      Get.snackbar("Welcome", "Logged in as ${emailController.text}");
      // navigate to home or whatever
    } finally {
      isSigningIn.value = false;
    }
  }

  Future<void> signUp() async {
    if (!(signUpFormKey.currentState?.validate() ?? false)) return;
    isSigningUp.value = true;
    try {
      // perform sign-up network call here
      await Future.delayed(const Duration(seconds: 1));
      // success popup
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2979FF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: Color(0xFF2979FF), size: 50),
                ),
                const SizedBox(height: 20),
                const Text("Successfully Registered",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                  "Your account has been registered successfully, now let's enjoy our features!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // close dialog
                      Get.offAllNamed('/signin'); // go to login page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2979FF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text("Continue",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } finally {
      isSigningUp.value = false;
    }
  }

  // ----------------------------
  // FORGOT PASSWORD FLOW
  // ----------------------------

  /// Step 1: Send/reset code (from Forgot Password page)
  Future<void> sendResetCode() async {
    // validate the forgot form
    if (!(forgotPasswordFormKey.currentState?.validate() ?? false)) return;

    isResetFlowLoading.value = true;
    try {
      // call backend to send OTP to forgotEmailController.text
      await Future.delayed(const Duration(seconds: 1));

      // navigate to verify page
      Get.toNamed('/verify');
      // start countdown
      startOtpTimer();
      Get.snackbar("OTP Sent", "A verification code has been sent to ${forgotEmailController.text}");
    } finally {
      isResetFlowLoading.value = false;
    }
  }

  /// Step 2: Verify OTP (from Verify page)
  Future<void> verifyCode() async {
    // simple validation here; better to use verifyFormKey validator in UI too
    final otpText = otpController.text.trim();
    if (otpText.length != otpLength) {
      Get.snackbar("Invalid Code", "Please enter the ${otpLength}-digit code");
      return;
    }

    isResetFlowLoading.value = true;
    try {
      // call backend to verify code
      await Future.delayed(const Duration(seconds: 1));

      // if success, navigate to reset page
      Get.toNamed('/reset');
    } finally {
      isResetFlowLoading.value = false;
    }
  }

  /// Step 3: Reset password (from Reset page)
  Future<void> resetPassword() async {
    if (!(resetFormKey.currentState?.validate() ?? false)) return;

    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (newPass != confirmPass) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    isResetFlowLoading.value = true;
    try {
      // call backend to update password
      await Future.delayed(const Duration(seconds: 1));

      // on success navigate to success / login screen
      Get.toNamed('/success');
    } finally {
      isResetFlowLoading.value = false;
    }
  }

  // ----------------------------
  // OTP Timer / Resend
  // ----------------------------
  /// Start or restart OTP countdown. When it reaches 0, user can resend.
  void startOtpTimer({int seconds = 30}) {
    _otpTimer?.cancel();
    otpTimer.value = seconds;
    canResendOTP.value = false;

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimer.value > 0) {
        otpTimer.value--;
      } else {
        canResendOTP.value = true;
        timer.cancel();
      }
    });
  }

  /// Called when user taps "Resend"
  Future<void> resendOtp() async {
    if (!canResendOTP.value) return;

    isResetFlowLoading.value = true;
    try {
      // call backend to resend OTP
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar("OTP Resent", "A new verification code has been sent to ${forgotEmailController.text}");
      // restart timer
      startOtpTimer();
    } finally {
      isResetFlowLoading.value = false;
    }
  }

  // ----------------------------
  // UTIL
  // ----------------------------
  /// Optional helper to quickly clear forgot/reset inputs
  void clearResetFlowInputs() {
    forgotEmailController.clear();
    otpController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    _otpTimer?.cancel();
    otpTimer.value = 0;
    canResendOTP.value = false;
  }

  // ----------------------------
  // LIFECYCLE
  // ----------------------------
  @override
  void onClose() {
    _otpTimer?.cancel();

    emailController.dispose();
    passwordController.dispose();

    signUpNameController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();

    forgotEmailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}
