import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/rounded_button.dart';
import 'package:sm_technology/auth/controller/auth_controller.dart';

class SuccessfulPopup extends StatelessWidget {
  const SuccessfulPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog( // ✅ Use Dialog instead of Scaffold
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/successful.png', height: 134, width: 134),
            const SizedBox(height: 20),
            const Text(
              "Success",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),

            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 200,
              child: const Text(
                "Your password is successfully created",
                textAlign: TextAlign.center,
                
                style: TextStyle(color:Colors.blueGrey,fontSize: 14),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              child: RoundedButton(
                label: "Continue",
                 onPressed: () { 
                      Get.back(); // close dialog
                      Get.offAllNamed('/signin'); // navigate to sign in
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
