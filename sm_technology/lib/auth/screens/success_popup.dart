import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_technology/auth/controller/auth_controller.dart';


class SuccessPopup extends StatelessWidget {
  const SuccessPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
             Image.asset('assets/images/Success.png', height: 150,width: 150,),
                const SizedBox(height: 20),
              const SizedBox(height: 20),
              const Text(
                "Successfully Registered",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Your account has been registered successfully, now let's enjoy our features!",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () { 
                  final controller = Get.find<AuthController>();
                    controller.emailController.clear();
                      controller.passwordController.clear();
                      controller.confirmPasswordController.clear();
  
                      Get.back(); // close dialog
                      Get.offAllNamed('/signin'); // navigate to sign in
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2979FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
