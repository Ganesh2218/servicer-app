import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/service_request_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../controllers/offer_controller.dart';
import '../controllers/marketplace_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';

class RequestDetailScreen extends StatelessWidget {
  final ServiceRequestEntity request;

  const RequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final OfferController offerController = Get.find<OfferController>();
    final MarketplaceController marketplaceController = Get.find<MarketplaceController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const AppText(
          'Request Details',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Media / hero
            if (request.mediaUrls.isNotEmpty)
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: request.mediaUrls.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      request.mediaUrls[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: AppColors.lightGrey, child: const Icon(Icons.broken_image, size: 50, color: AppColors.grey)),
                    );
                  },
                ),
              )
            else
              Container(
                height: 200,
                color: AppColors.lightBackground,
                child: const Center(
                  child: Icon(Icons.image_not_supported_outlined, size: 60, color: AppColors.grey),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Posted-by user section ──
                  Obx(() {
                    final UserEntity? user = marketplaceController.getUserForRequest(request.createdBy);
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: AppColors.primaryColor.withOpacity(0.12),
                            backgroundImage: (user?.profileImage != null && user!.profileImage!.isNotEmpty)
                                ? NetworkImage(user.profileImage!)
                                : null,
                            child: (user?.profileImage == null || user!.profileImage!.isEmpty)
                                ? Text(
                                    user != null ? user.name.isNotEmpty ? user.name[0].toUpperCase() : '?' : '?',
                                    style: const TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 14),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  user?.name ?? 'Unknown User',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                                const SizedBox(height: 2),
                                AppText(
                                  user?.email ?? '',
                                  fontSize: 12,
                                  color: AppColors.grey,
                                ),
                                if (user?.role != null && user!.role.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.accentColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: AppText(
                                      user.role,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Rating badge
                          if (user?.rating != null)
                            Column(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 22),
                                AppText(
                                  user!.rating!.toStringAsFixed(1),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                                const AppText(
                                  'Rating',
                                  fontSize: 10,
                                  color: AppColors.grey,
                                ),
                              ],
                            ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: AppText(
                      request.category,
                      color: AppColors.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  AppText(
                    request.title,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  // Description
                  AppText(
                    request.description,
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                  const SizedBox(height: 24),
                  // Budget
                  if (request.budget != null) ...[
                    AppText(
                      'Budget: ₹${request.budget!.toStringAsFixed(2)}',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                    const SizedBox(height: 24),
                  ],
                  // Location
                  if (request.address != null && request.address!.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 16, color: AppColors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                          child: AppText(
                            request.address!,
                            fontSize: 13,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                  const Divider(),
                  const SizedBox(height: 24),
                  // Offer section
                  const AppText(
                    'Submit Your Response',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: 'Offer Price',
                    hintText: 'Enter your price (₹)',
                    controller: offerController.priceController,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.attach_money, color: AppColors.primaryColor),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: 'Message',
                    hintText: 'Message to Customer',
                    controller: offerController.messageController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),
                  Obx(() => PrimaryButton(
                    'Send Response',
                    isLoading: offerController.isLoading.value,
                    onPressed: () => offerController.submitOffer(request),
                  )),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
