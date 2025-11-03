import 'package:get/get.dart';
import '../../features/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../auth/screens/sign_in_page.dart';
import '../../auth/screens/sign_up_page.dart';
import '../../auth/screens/Success_Popup.dart';
import '../../auth/screens/forgot_password_page.dart';
import '../../auth/screens/verify_code_page.dart';
import '../../auth/screens/reset_password_page.dart';
import '../../auth/screens/successful_popup.dart';
import '../../auth/screens/enable_location_page.dart';
import '../../auth/screens/select_language_page.dart';

class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const signIn = '/signin';
  static const signUp = '/signup';
  static const success = '/success';
  static const forgot='/forgot';
  static const verify='/verify';
  static const reset='/reset';
  static const successful='/successful';
  static const location='/enable_location';
  static const language='/language';
  

  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: signIn, page: () => const SignInPage()),
    GetPage(name: signUp, page: () => const SignUpPage()),
    GetPage(name: success, page: () => const SuccessPopup()),
     GetPage(name: forgot, page: () => const ForgotPasswordPage()),
  GetPage(name: verify, page: () => const VerifyCodePage()),
  GetPage(name: reset, page: () => const ResetPasswordPage()),
  GetPage(name: successful, page: () => const SuccessfulPopup()),
  GetPage(name: location, page: () => const EnableLocationPage()),
  GetPage(name: language, page: () =>  SelectLanguagePage()),
  ];
}
