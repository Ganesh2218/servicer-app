import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/service_request_entity.dart';
import '../controllers/offer_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';

class RequestDetailScreen extends StatelessWidget {
  final ServiceRequestEntity request;

  const RequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final OfferController controller = Get.find<OfferController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Request Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentColor.withValues(alpha: 0.2),
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
                  AppText(
                    request.title,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  AppText(
                    request.description,
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                  const SizedBox(height: 24),
                  if (request.budget != null) ...[
                    AppText(
                      'Customer Budget: \$${request.budget!.toStringAsFixed(2)}',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                    const SizedBox(height: 24),
                  ],
                  const Divider(),
                  const SizedBox(height: 16),
                  const AppText(
                    'Submit Your Response',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  
                  AppTextField(
                    hintText: 'Your Offer Price (\$)',
                    controller: controller.priceController,
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.attach_money, color: AppColors.grey),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    hintText: 'Message to Customer',
                    controller: controller.messageController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),
                  Obx(() => PrimaryButton(
                    'Send Response',
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.submitOffer(request),
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
