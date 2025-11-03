import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  final isLoading = false.obs;

  Future<void> enableLocation() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));

    LocationPermission permission = await Geolocator.requestPermission();
    isLoading.value = false;

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Get.toNamed('/language');
    } else {
      Get.snackbar("Permission Denied",
          "You need to allow location access to continue.");
    }
  }
}
