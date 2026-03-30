import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:servicer/core/utils/app_functions.dart';
import 'package:servicer/core/widgets/primary_button.dart';
import 'package:servicer/routes/app_routes.dart';
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
        onPressed: () => Get.find<MainNavigationController>().changeIndex(
          1,
        ), // Go to Create tab
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
                Icon(
                  Icons.assignment_outlined,
                  size: 80,
                  color: AppColors.grey.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                const AppText(
                  'You haven\'t posted any services yet.',
                  color: AppColors.grey,
                ),
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
              return _buildServiceCard(request, context);
            },
          ),
        );
      }),
    );
  }

  Widget _buildServiceCard(request, BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Get.toNamed(Routes.requestDetails, arguments: request),
        child: Padding(
          padding: EdgeInsets.all(width * 0.04), // responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔥 Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor.withOpacity(0.15),
                          AppColors.accentColor.withOpacity(0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      request.category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  Text(
                    AppFunctions.formatDate(request.timestamp),
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// 🧠 Title
              Text(
                request.title,
                style: TextStyle(
                  fontSize: width * 0.045, // responsive font
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 6),

              /// 📄 Description
              Text(
                request.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: width * 0.032,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 14),

              /// 📍 Location + Budget
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      request.address ?? "Location not set",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: width * 0.03,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  if (request.budget != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '₹${request.budget!.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),

              Row(
                children: [
                  Spacer(),
                  Expanded(
                    child: PrimaryButton(
                      "Edit",
                      onPressed: () {
                        Get.snackbar(
                          'Edit Service',
                          'Editing feature coming soon!',
                        );
                      },
                    ),
                  ),

                  Expanded(
                    child: PrimaryButton(
                      "Delete",
                      onPressed: () {
                        _confirmDelete(request.id);
                      },
                    ),
                  ),
                  /*  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () => _confirmDelete(request.id),
                  ), */
                ],
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(String id) {
    Get.defaultDialog(
      title: 'Delete Service?',
      titleStyle: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: AppColors.primaryColor,
      ),
      middleText: 'Are you sure you want to delete this service request?',
      middleTextStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: AppColors.textDark,
      ),
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
