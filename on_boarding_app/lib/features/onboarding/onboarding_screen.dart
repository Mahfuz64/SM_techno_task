import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../locations/location.dart';
import '../../common_widget/custom_button.dart';
import '../../constants/app_constants.dart';
import 'onboarding_page.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  
  final List<Map<String, String>> onboardingData = [
    {
      'video': 'assets/videos/onboarding_1.mp4', 
      'title': 'Discover the world, one journey at a time.',
      'description': 'From hidden gems to iconic destinations, we make travel simple, inspiring, and unforgettable. Start your next adventure today.',
    },
    {
      'video': 'assets/videos/onboarding_2.mp4', 
      'title': 'Explore new horizons, one step at a time.',
      'description': 'Every trip holds a story wanting to be lived. Let us guide you to experiences that inspire, connect, and last a lifetime.',
    },
    {
      'video': 'assets/videos/onboarding_3.mp4', 
      'title': 'See the beauty, one journey at a time.',
      'description': 'Travel made simple and exciting—discover places you’ll love and moments you’ll never forget.',
    },
  ];

  void _goToLocationScreen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingKey, true);
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LocationScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(gradient: AppConstants.mainGradient)),

          
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == onboardingData.length - 1);
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPageContent(
                videoPath: onboardingData[index]['video']!, 
                title: onboardingData[index]['title']!,
                description: onboardingData[index]['description']!,
              );
            },
          ),

          
          Positioned(
            top: 60,
            right: 20,
            child: TextButton(
              onPressed: _goToLocationScreen,
              child: const Text('Skip', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),

          
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0, left: 30, right: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: onboardingData.length,
                    effect: const ExpandingDotsEffect(
                      dotColor: Colors.white30,
                      activeDotColor: Colors.white,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 4,
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: 'Next', 
                    onPressed: () {
                      if (onLastPage) {
                        _goToLocationScreen();
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


