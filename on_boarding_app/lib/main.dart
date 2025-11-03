import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/locations/location.dart';
import 'helpers/notification_helper.dart';
import 'constants/app_constants.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
    FlutterLocalNotificationsPlugin();
   class CenterConstrainedWrapper extends StatelessWidget {
    final Widget child;
    const CenterConstrainedWrapper({super.key, required this.child});

    @override
    Widget build(BuildContext context) {
      
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 600, 
          ),
          child: child,
        ),
      );
    }
  }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  tz.initializeTimeZones();
  
  tz.setLocalLocation(tz.getLocation('Etc/UTC')); 

  await NotificationHelper.initNotifications(flutterLocalNotificationsPlugin);
  
  
  final prefs = await SharedPreferences.getInstance();
  final bool hasSeenOnboarding = prefs.getBool(AppConstants.onboardingKey) ?? false;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  

  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Travel Alarm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppConstants.scaffoldColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: AppConstants.headingStyle.copyWith(fontSize: 20),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(color: Colors.white70),
          labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        colorScheme: const ColorScheme.dark(
          primary: AppConstants.primaryColor,
          secondary: AppConstants.accentColor,
        ),
        
        extensions: <ThemeExtension<dynamic>>[
          GradientBackgroundExtension(
            gradient: AppConstants.mainGradient,
          ),
        ],
      ),
      home: const OnboardingScreen(),
    );
  }
}


class GradientBackgroundExtension extends ThemeExtension<GradientBackgroundExtension> {
  final Gradient? gradient;

  const GradientBackgroundExtension({this.gradient});

  @override
  ThemeExtension<GradientBackgroundExtension> copyWith({Gradient? gradient}) {
    return GradientBackgroundExtension(
      gradient: gradient ?? this.gradient,
    );
  }

  @override
  ThemeExtension<GradientBackgroundExtension> lerp(
      covariant ThemeExtension<GradientBackgroundExtension>? other, double t) {
    if (other is! GradientBackgroundExtension) {
      return this;
    }
    return GradientBackgroundExtension(
      gradient: Gradient.lerp(gradient, other.gradient, t),
    );
  }
}