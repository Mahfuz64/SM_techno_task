import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controller/home_model.dart';

class HomeController extends GetxController {
  // Observables for state management
  final isLoading = true.obs;
  final products = <Product>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading.value = true;
    errorMessage.value = '';

    const url = 'https://api.restful-api.dev/objects';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);

        products.value =
            jsonList.map((json) => Product.fromJson(json)).toList();

        print('✅ Successfully fetched ${products.length} products.');
      } else {
        errorMessage.value =
            'Failed to load products. Status Code: ${response.statusCode}';
        print(errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Error: ${e.toString()}';
      print('❌ Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
