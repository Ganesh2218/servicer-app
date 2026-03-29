import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/marketplace_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_text.dart';
import '../../routes/app_routes.dart';

class MarketplaceScreen extends GetView<MarketplaceController> {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Marketplace'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  onChanged: controller.updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search services...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                    filled: true,
                    fillColor: AppColors.lightBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Filter & Sort Row
                Row(
                  children: [
                    // Category Filter
                    Expanded(
                      child: Obx(() => DropdownButtonFormField<String>(
                        initialValue: controller.selectedCategory.value,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        items: controller.categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                        onChanged: (val) => controller.updateCategory(val!),
                      )),
                    ),
                    const SizedBox(width: 8),
                    // Sort
                    Expanded(
                      child: Obx(() => DropdownButtonFormField<String>(
                        initialValue: controller.sortBy.value,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        items: controller.sortOptions.map((opt) => DropdownMenuItem(value: opt, child: Text(opt))).toList(),
                        onChanged: (val) => controller.updateSort(val!),
                      )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Feed
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.filteredRequests.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredRequests.isEmpty) {
                return const Center(child: AppText('No services found.', color: AppColors.grey));
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchRequests(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredRequests.length,
                  itemBuilder: (context, index) {
                    final request = controller.filteredRequests[index];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () => Get.toNamed(Routes.requestDetails, arguments: request),
                        borderRadius: BorderRadius.circular(16),
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
                                      color: AppColors.accentColor.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: AppText(
                                      request.category,
                                      color: AppColors.primaryColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  AppText(
                                    _formatDate(request.timestamp),
                                    color: AppColors.grey,
                                    fontSize: 11,
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
                                children: [
                                  Expanded(
                                    child: AppText(
                                      request.address ?? 'Location Info',
                                      color: AppColors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (request.budget != null)
                                    AppText(
                                      '\$${request.budget!.toStringAsFixed(0)}',
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.success,
                                      fontSize: 16,
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
