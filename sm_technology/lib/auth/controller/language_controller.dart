import 'package:get/get.dart';

class LanguageItem {
  final String name;
  final String flag;
  LanguageItem({required this.name, required this.flag});
}

class LanguageController extends GetxController {
  final selectedLanguage = ''.obs;

  final languages = <LanguageItem>[
    LanguageItem(name: 'English (US)', flag: '🇺🇸'),
    LanguageItem(name: 'Indonesia', flag: '🇮🇩'),
    LanguageItem(name: 'Afghanistan', flag: '🇦🇫'),
    LanguageItem(name: 'Algeria', flag: '🇩🇿'),
    LanguageItem(name: 'Malaysia', flag: '🇲🇾'),
    LanguageItem(name: 'Arabic (UAE)', flag: '🇦🇪'), // Clarified Arabic region
    
    // --- Added More Countries/Languages ---
    LanguageItem(name: 'Spanish (Spain)', flag: '🇪🇸'),
    LanguageItem(name: 'French (France)', flag: '🇫🇷'),
    LanguageItem(name: 'German (Germany)', flag: '🇩🇪'),
    LanguageItem(name: 'Chinese (Mandarin)', flag: '🇨🇳'),
    LanguageItem(name: 'Japanese', flag: '🇯🇵'),
    LanguageItem(name: 'Korean', flag: '🇰🇷'),
    LanguageItem(name: 'Portuguese (Brazil)', flag: '🇧🇷'),
    LanguageItem(name: 'Russian', flag: '🇷🇺'),
    LanguageItem(name: 'Italian', flag: '🇮🇹'),
    LanguageItem(name: 'Turkey', flag: '🇹🇷'),
    LanguageItem(name: 'Vietnam', flag: '🇻🇳'),
    LanguageItem(name: 'India (Hindi)', flag: '🇮🇳'),
    // --- End Added Countries/Languages ---

  ].obs;

  void selectLanguage(String lang) {
    selectedLanguage.value = lang;
  }

  void confirmSelection() {
    if (selectedLanguage.value.isEmpty) {
      Get.snackbar("Select a Language", "Please choose one language to continue");
      return;
    }
    Get.snackbar("Language Selected", "You selected ${selectedLanguage.value}");
    Get.offAllNamed('/signin');
  }
}