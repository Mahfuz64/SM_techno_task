import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/language_controller.dart';
import '../widgets/rounded_button.dart';
import '../screens/home_page.dart'; // ✅ corrected import path

class SelectLanguagePage extends StatelessWidget {
  SelectLanguagePage({Key? key}) : super(key: key);

  final controller = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Get.snackbar("Menu", "Menu button pressed!");
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "What is Your Mother Language",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Discover what is a podcast description and podcast summary.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 30),

              // 🔥 Reactive language list
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: controller.languages.length,
                    itemBuilder: (context, index) {
                      final language = controller.languages[index];
                      final isSelected =
                          controller.selectedLanguage.value == language.name;

                      return GestureDetector(
                        onTap: () => controller.selectLanguage(language.name),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.withOpacity(0.05)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey.shade200,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            leading: Text(language.flag,
                                style: const TextStyle(fontSize: 28)),
                            title: Text(
                              language.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: Colors.black,
                              ),
                            ),
                            trailing: SizedBox(
                              width: 80,
                              child: ElevatedButton(
                                onPressed: () =>
                                    controller.selectLanguage(language.name),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? Colors.blueAccent
                                      : Colors.grey.shade200,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  isSelected ? "Selected" : "Select",
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.blueAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              const SizedBox(height: 15),

              // ✅ Continue Button
              RoundedButton(
                label: "Continue",
                onPressed: () {
                  if (controller.selectedLanguage.isEmpty) {
                    Get.snackbar("Select a language",
                        "Please choose your language before continuing.",
                        snackPosition: SnackPosition.BOTTOM);
                  } else {
                    // 🟢 Move to HomePage (replace current route stack)
                    Get.offAll(() => const HomePage());
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
