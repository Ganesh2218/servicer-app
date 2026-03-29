import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../data/repositories/review_repository_impl.dart';

class RatingDialog extends StatefulWidget {
  final String providerId;
  final String customerId;
  final String requestId;

  const RatingDialog({
    super.key,
    required this.providerId,
    required this.customerId,
    required this.requestId,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 5.0;
  final TextEditingController _reviewController = TextEditingController();
  final ReviewRepositoryImpl _reviewRepository = ReviewRepositoryImpl();
  bool _isLoading = false;

  Future<void> _submitReview() async {
    setState(() => _isLoading = true);
    try {
      await _reviewRepository.submitReview(
        widget.providerId,
        widget.customerId,
        widget.requestId,
        _rating,
        _reviewController.text.trim(),
      );
      Get.back();
      Get.snackbar('Thank You', 'Your review has been submitted.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit review');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppText(
              'Rate the Service',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            AppTextField(
              hintText: 'Write your review here...',
              controller: _reviewController,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              'Submit Review',
              isLoading: _isLoading,
              onPressed: _submitReview,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }
}
