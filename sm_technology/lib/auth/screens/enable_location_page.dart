import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/location_controller.dart';
import '../widgets/rounded_button.dart';

class EnableLocationPage extends StatelessWidget {
  const EnableLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/Maps.png', height: 120,width: 120,),
              const SizedBox(height: 30),
              const Text(
                "Enable Location",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: const Text(
                  "Kindly allow us to access your location to provide you with suggestions for nearby salons.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
              const SizedBox(height: 40),
              Obx(() => RoundedButton(
                    label: controller.isLoading.value ? "Enabling..." : "Enable",
                    loading: controller.isLoading.value,
                    onPressed: controller.enableLocation,
                  )),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.toNamed('/language'),
                child: const Text(
                  "Skip, Not Now",
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
