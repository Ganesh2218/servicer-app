import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../controllers/service_request_controller.dart';
import '../../core/constants/app_constants.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class CreateServiceRequestScreen extends GetView<ServiceRequestController> {
  const CreateServiceRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const AppText(
          'Create Your Service',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: AppColors.textLight,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Header Info
            _infoCard(),

            const SizedBox(height: 24),

            /// 1️⃣ Service Type
            _sectionTitle("What service do you provide?"),
            const SizedBox(height: 10),
            _buildCategoryDropdown(),

            const SizedBox(height: 24),

            /// 2️⃣ Service Details
            _sectionTitle("Service details"),
            const SizedBox(height: 12),

            AppTextField(
              label: "Service name",
              hintText: "e.g. Home Plumbing, AC Repair",
              controller: controller.titleController,
              prefixIcon: const Icon(Icons.home_repair_service),
            ),

            const SizedBox(height: 16),

            AppTextField(
              label: "Describe your service",
              hintText: "Explain what you offer to customers",
              controller: controller.descriptionController,
              maxLines: 4,
              prefixIcon: const Icon(Icons.notes),
            ),

            const SizedBox(height: 24),

            /// 3️⃣ Pricing Type
            _sectionTitle("How do you charge?"),
            const SizedBox(height: 12),
            _pricingSelector(),

            const SizedBox(height: 24),

            /// 4️⃣ Price
            _sectionTitle("Set your price"),
            const SizedBox(height: 10),

            Obx(() {
              String label = "Enter price";

              switch (controller.selectedPricingType.value) {
                case 'daily':
                  label = "Price per day";
                  break;
                case 'monthly':
                  label = "Price per month";
                  break;
                case 'completion':
                  label = "Total service price";
                  break;
              }

              return AppTextField(
                hintText: label,
                controller: controller.budgetController,
                keyboardType: TextInputType.number,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: AppText("₹", fontSize: 20),
                ),
              );
            }),

            const SizedBox(height: 24),

            /// 5️⃣ Location
            _sectionTitle("Where do you provide service?"),
            const SizedBox(height: 10),
            _buildLocationSearch(),

            const SizedBox(height: 24),

            /// 6️⃣ Photos
            _sectionTitle("Add photos (optional)"),
            const SizedBox(height: 10),
            _buildMediaGrid(),

            const SizedBox(height: 30),

            /// Submit
            Obx(
              () => PrimaryButton(
                "Create Service",
                isLoading: controller.isLoading.value,
                onPressed: controller.createRequest,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Info Card
  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.lightbulb_outline, color: AppColors.primaryColor),
          SizedBox(width: 10),
          Expanded(
            child: AppText(
              "Create your service and start getting customers nearby.",
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return AppText(
      title,
      fontWeight: FontWeight.w600,
      fontSize: 16,
      color: AppColors.textDark,
    );
  }

  /// 🔹 Category Dropdown
  Widget _buildCategoryDropdown() {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedCategory.value,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
        hint: const AppText("Select service type"),
        items: controller.categories
            .map((e) => DropdownMenuItem(value: e, child: AppText(e)))
            .toList(),
        onChanged: (val) => controller.selectedCategory.value = val!,
      ),
    );
  }

  /// 🔹 Pricing Selector
  Widget _pricingSelector() {
    return Row(
      children: [
        _pricingChip("Daily", "daily"),
        const SizedBox(width: 8),
        _pricingChip("Monthly", "monthly"),
        const SizedBox(width: 8),
        _pricingChip("One-time", "completion"),
      ],
    );
  }

  Widget _pricingChip(String title, String value) {
    return Obx(() {
      final isSelected = controller.selectedPricingType.value == value;

      return Expanded(
        child: GestureDetector(
          onTap: () => controller.selectedPricingType.value = value,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: Center(
              child: AppText(
                title,
                color: isSelected ? Colors.white : AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLocationSearch() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GooglePlaceAutoCompleteTextField(
            focusNode: controller.locationFocusNode,
            textEditingController: controller.locationController,
            googleAPIKey: AppConstants.mapKey,
            inputDecoration: InputDecoration(
              labelText: "Job Location",
              labelStyle: const TextStyle(
                color: AppColors.grey,
                fontFamily: 'Inter',
                fontSize: 14,
              ),
              hintText: "Enter job location...",
              hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
              prefixIcon: const Icon(
                Icons.location_on_outlined,
                color: AppColors.primaryColor,
                size: 22,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1.5,
                ),
              ),
            ),
            debounceTime: 800,
            itemClick: (Prediction prediction) {
              controller.locationController.text = prediction.description!;
              controller.locationFocusNode.unfocus();
              controller.address.value = prediction.description!;
              controller.updateLocationFromPlaceId(prediction.placeId!);
            },
            seperatedBuilder: const Divider(height: 1),
            itemBuilder: (context, index, Prediction prediction) {
              return Container(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: AppColors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppText(
                        prediction.description ?? "",
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            dense: true,
            onTap: () {
              // Trigger fetch or just show what's in controller
            },
            leading: const Icon(
              Icons.my_location,
              color: AppColors.success,
              size: 20,
            ),
            title: Obx(
              () => AppText(
                controller.address.value,
                fontSize: 13,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              size: 18,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaGrid() {
    return Obx(
      () => controller.pickedFiles.isEmpty
          ? GestureDetector(
              onTap: controller.pickMedia,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.lightBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.grey.withOpacity(0.15),
                    style: BorderStyle.solid,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      color: AppColors.grey,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    AppText(
                      'Upload supporting photos',
                      color: AppColors.grey,
                      fontSize: 13,
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.pickedFiles.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            controller.pickedFiles[index],
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: GestureDetector(
                            onTap: () => controller.removeFile(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
