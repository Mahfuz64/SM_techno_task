import 'package:flutter/material.dart';

class AppConstants {
  
  static const String locationKey = 'location';
  static const String alarmsKey = 'alarms';
  static const String onboardingKey = 'hasSeenOnboarding';

  
  static const Color primaryColor = Color(0xFF5A44E0); 
  static const Color accentColor = Color(0xFFC044E0); 
  static const Color scaffoldColor = Color(0xFF140F38); 
  static const Color cardColor = Color(0xFF201B4B); 

  
  static const LinearGradient mainGradient = LinearGradient(
    colors: [
      Color(0xFF140F38), 
      Color(0xFF331464), 
      Color(0xFF5A44E0), 
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  
  static final BoxDecoration mainGradientBoxDecoration = BoxDecoration(
    gradient: mainGradient,
  );

  
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 12,
    color: Colors.white70,
  );

  
  
  
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        
        backgroundColor: cardColor.withOpacity(0.5), 
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: Colors.white38),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      );

  
  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
        
        backgroundColor: primaryColor, 
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      );
}
