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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Service'),
        automaticallyImplyLeading:
            false, // Prevents back button in navigation tab
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  'Post your job and get responses from nearby providers.',
                  color: AppColors.grey,
                  fontSize: 14,
                ),
                const SizedBox(height: 24),

                // Title
                AppTextField(
                  hintText: 'Job Title (e.g. Fix leaking pipe)',
                  controller: controller.titleController,
                  prefixIcon: const Icon(
                    Icons.title_outlined,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                AppTextField(
                  hintText: 'Describe what you need...',
                  controller: controller.descriptionController,
                  maxLines: 4,
                  prefixIcon: const Icon(
                    Icons.description_outlined,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 16),

                // Category & Budget Row
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.grey.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.selectedCategory.value,
                              isExpanded: true,
                              onChanged: (val) =>
                                  controller.selectedCategory.value = val!,
                              items: controller.categories.map((cat) {
                                return DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: AppTextField(
                        hintText: 'Budget',
                        controller: controller.budgetController,
                        keyboardType: TextInputType.number,
                        prefixIcon: const Icon(
                          Icons.attach_money_outlined,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Location Section
                const AppText(
                  'Location',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.grey.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      GooglePlaceAutoCompleteTextField(
                        textEditingController: controller.locationController,
                        googleAPIKey: AppConstants.mapKey,
                        focusNode: controller.locationFocusNode,
                        inputDecoration: InputDecoration(
                          hintText: "Search Location...",
                          hintStyle: const TextStyle(color: AppColors.grey),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        debounceTime: 800,
                        itemClick: (Prediction prediction) {
                          controller.locationController.text =
                              prediction.description!;
                          controller.locationFocusNode.unfocus();

                          controller.locationController.selection =
                              TextSelection.fromPosition(
                                TextPosition(
                                  offset: prediction.description!.length,
                                ),
                              );

                          print(prediction.description!);

                          controller.address.value = prediction.description!;
                          controller.updateLocationFromPlaceId(
                            prediction.placeId!,
                          );
                        },
                        seperatedBuilder: const Divider(),
                        itemBuilder: (context, index, Prediction prediction) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: AppColors.grey,
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Text(prediction.description ?? ""),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        onTap: () {
                          controller.address.value = 'Fetching location...';
                        },
                        leading: const Icon(
                          Icons.my_location,
                          color: AppColors.primaryColor,
                        ),
                        title: Obx(
                          () => AppText(
                            controller.address.value,
                            fontSize: 13,
                            maxLines: 2,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Media Grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AppText(
                      'Media / Photos',
                      fontWeight: FontWeight.bold,
                    ),
                    TextButton.icon(
                      onPressed: controller.pickMedia,
                      icon: const Icon(Icons.add_a_photo, size: 18),
                      label: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Obx(
                  () => controller.pickedFiles.isEmpty
                      ? Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.grey.withValues(alpha: 0.2),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                color: AppColors.grey,
                                size: 32,
                              ),
                              SizedBox(height: 4),
                              AppText(
                                'No images added',
                                color: AppColors.grey,
                                fontSize: 12,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.pickedFiles.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        controller.pickedFiles[index],
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.removeFile(index),
                                        child: const CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.red,
                                          child: Icon(
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
                ),
                const SizedBox(height: 40),

                // Submit Button
                Obx(
                  () => PrimaryButton(
                    'Post Service Request',
                    isLoading: controller.isLoading.value,
                    onPressed: controller.createRequest,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),

          // Loading Overlay
          Obx(
            () => controller.isLoading.value
                ? Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
