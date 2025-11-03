import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen height once for responsive calculations
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            // Use fixed padding for horizontal content boundaries
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Responsive spacing from the top (e.g., 5% of screen height)
                SizedBox(height: screenHeight * 0.05),
                
                Image.asset(
                  'assets/images/car.png',
                  // Responsive image size (e.g., 15% of screen height)
                  height: screenHeight * 0.15,
                  width: screenHeight * 0.15,
                  color: Colors.blue, // optional tint
                ),
                const SizedBox(height: 24),
                const Text(
                  "Theory test in my language",
                  // Consider using a responsive font size if needed:
                  // style: TextStyle(fontSize: screenWidth * 0.06, fontWeight: FontWeight.bold)
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  "I must write the real test in English. This app helps you understand the materials in your language.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),

                // Use a Spacer to fill the remaining vertical space, pushing the loader down
                const Spacer(),
      
                SpinKitCircle(color: Colors.blue, size: 60.0),
                
                // Responsive spacing for the bottom (e.g., 5% of screen height)
                SizedBox(height: screenHeight * 0.05),
              ],  
            ),
          ),
        ),
      ),
    );
  }
}