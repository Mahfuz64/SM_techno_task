import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart'; // 👈 make sure this import matches your folder structure

class OnboardingController extends GetxController {
  final pageController = PageController();
  var currentPage = 0.obs;

  void nextPage() {
    if (currentPage.value < 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // ✅ Navigate to Sign In when user taps "Get Started"
      Get.offAllNamed(AppRoutes.signIn);
    }
  }

  void updatePage(int index) {
    currentPage.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
