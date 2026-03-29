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
        title: const AppText(
          'Marketplace',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
        ),
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
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search services...',
                    hintStyle: const TextStyle(
                      color: AppColors.grey,
                      fontFamily: 'Inter',
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primaryColor,
                    ),
                    filled: true,
                    fillColor: AppColors.lightBackground,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColors.grey.withOpacity(0.15),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: AppColors.grey.withOpacity(0.15),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Filter & Sort Row
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => DropdownButtonFormField<String>(
                          value: controller.selectedCategory.value,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.textDark,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            filled: true,
                            fillColor: AppColors.lightBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.grey.withOpacity(0.15),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.grey.withOpacity(0.15),
                              ),
                            ),
                          ),
                          items: controller.categories
                              .map(
                                (cat) => DropdownMenuItem(
                                  value: cat,
                                  child: AppText(cat, fontSize: 13),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => controller.updateCategory(val!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Sort
                    Expanded(
                      child: Obx(
                        () => DropdownButtonFormField<String>(
                          value: controller.sortBy.value,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            color: AppColors.textDark,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                            filled: true,
                            fillColor: AppColors.lightBackground,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.grey.withOpacity(0.15),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.grey.withOpacity(0.15),
                              ),
                            ),
                          ),
                          items: controller.sortOptions
                              .map(
                                (opt) => DropdownMenuItem(
                                  value: opt,
                                  child: AppText(opt, fontSize: 13),
                                ),
                              )
                              .toList(),
                          onChanged: (val) => controller.updateSort(val!),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Feed
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.filteredRequests.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredRequests.isEmpty) {
                return const Center(
                  child: AppText('No services found.', color: AppColors.grey),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchRequests(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredRequests.length,
                  itemBuilder: (context, index) {
                    final request = controller.filteredRequests[index];
                    return _buildRequestCard(request, context);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(request, BuildContext context) {
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
                    _formatDate(request.timestamp),
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

              const SizedBox(height: 12),
              const Divider(),

              /// 👤 User Info
              Obx(() {
                final user = controller.getUserForRequest(request.createdBy);

                return Row(
                  children: [
                    CircleAvatar(
                      radius: width * 0.045,
                      backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                      backgroundImage: user?.profileImage != null
                          ? NetworkImage(user!.profileImage!)
                          : null,
                      child: user?.profileImage == null
                          ? Text(
                              user?.name[0].toUpperCase() ?? "?",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? "Unknown",
                            style: TextStyle(
                              fontSize: width * 0.032,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            user?.role ?? "",
                            style: TextStyle(
                              fontSize: width * 0.028,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (user?.rating != null)
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text(
                            user!.rating!.toStringAsFixed(1),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
