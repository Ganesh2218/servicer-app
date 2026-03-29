import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_services_controller.dart';
import '../controllers/main_navigation_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_text.dart';

class MyServicesScreen extends GetView<MyServicesController> {
  const MyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const AppText(
          'My Services',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.find<MainNavigationController>().changeIndex(1), // Go to Create tab
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.myRequests.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.myRequests.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined, size: 80, color: AppColors.grey.withOpacity(0.5)),
                const SizedBox(height: 16),
                const AppText('You haven\'t posted any services yet.', color: AppColors.grey),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchMyRequests(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.myRequests.length,
            itemBuilder: (context, index) {
              final request = controller.myRequests[index];
              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accentColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: AppText(
                              request.category,
                              color: AppColors.primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppColors.primaryColor, size: 20),
                                onPressed: () {
                                  // Implementation for edit
                                  Get.snackbar('Edit Service', 'Editing feature coming soon!');
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                onPressed: () => _confirmDelete(request.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AppText(
                        request.title,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                      const SizedBox(height: 8),
                      AppText(
                        request.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.grey,
                        fontSize: 13,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            '${request.timestamp.day}/${request.timestamp.month}/${request.timestamp.year}',
                            color: AppColors.grey,
                            fontSize: 12,
                          ),
                          if (request.budget != null)
                            AppText(
                              '\$${request.budget!.toStringAsFixed(0)}',
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                              fontSize: 16,
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _confirmDelete(String id) {
    Get.defaultDialog(
      title: 'Delete Service?',
      titleStyle: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryColor),
      middleText: 'Are you sure you want to delete this service request?',
      middleTextStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.textDark),
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        controller.deleteRequest(id);
        Get.back();
      },
    );
  }
}
