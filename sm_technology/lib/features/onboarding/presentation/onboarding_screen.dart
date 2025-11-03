import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    // Get screen dimensions once for responsive calculations
    final size = MediaQuery.of(context).size;

    final pages = [
      OnboardingPage( // Removed 'const' since we now pass dynamic sizes
        imagePath: 'assets/images/onboarding.png',
        title: "Best online courses in the world",
        description:
            "Now you can learn anywhere, anytime, even if there is no internet access!",
        screenHeight: size.height, // Pass height to OnboardingPage
      ),
      OnboardingPage( // Removed 'const'
        imagePath: 'assets/images/onboarding1.png',
        title: "Explore your new skill today",
        description:
            "Our platform helps you explore new skills. Let's learn & grow together!",
        screenHeight: size.height, // Pass height to OnboardingPage
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 💡 Page content
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.updatePage,
                  itemCount: pages.length,
                  itemBuilder: (_, index) => pages[index],
                ),
              ),

              // 💡 Smooth Page Indicator (just below text)
              SmoothPageIndicator(
                controller: controller.pageController,
                count: pages.length,
                effect: const WormEffect(
                  activeDotColor: Color(0xFF2979FF),
                  dotColor: Color(0xFFD6E4FF),
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                ),
              ),

              // Responsive vertical spacing before the button
              SizedBox(height: size.height * 0.03), 

              // 💡 Full-width blue button
              Padding(
                // Consistent horizontal padding
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2979FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      // Consistent vertical padding
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      controller.currentPage.value == 0
                          ? "Next"
                          : "Get Started",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final double screenHeight; // Added property for responsive height

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.screenHeight, // Required in constructor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Responsive Image Height (e.g., 30% of screen height)
          Image.asset(
            imagePath,
            height: screenHeight * 0.30, 
            fit: BoxFit.contain,
          ),
          // Responsive Spacing
          SizedBox(height: screenHeight * 0.04), 
          Text(
            title,
            textAlign: TextAlign.center,
            // Font sizes are generally kept fixed but can be made responsive 
            // if supporting extreme screen sizes (e.g., tablets vs watches)
            style: const TextStyle( 
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}