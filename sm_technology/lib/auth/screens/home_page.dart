import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart'; // ✅ corrected path (controllers, not controller)

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Product List'),
        backgroundColor: const Color(0xFF2979FF),
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          // ⏳ Show a loading indicator while fetching
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          // ⚠️ Show error message
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchProducts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // ✅ Display the fetched data list
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            final data = product.data ?? {};

            // Extract some readable info from `data` map
            String subtitleText = '';
            if (data.isNotEmpty) {
              subtitleText = data.entries
                  .map((e) => '${e.key}: ${e.value}')
                  .join(', ');
            } else {
              subtitleText = 'No details available';
            }

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  child: Text(
                    product.id,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  subtitleText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.fetchProducts,
        backgroundColor: const Color(0xFF2979FF),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
