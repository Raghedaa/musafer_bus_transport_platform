import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../core/shared/custom_snackbar.dart';
import '../../../../data/repositories/booking_repository.dart';
import '../../../booking_history/controllers/booking_history_controller.dart';
import '../../../booking_history/view/screen/booking_history_screen.dart';
import '../../../main_layout/controller/main_layout_controller.dart';

class TripRatingDialog extends StatefulWidget {
  final String? companyName;
  final String? driverName;
  final Future<void> Function({
  required double companyRating,
  required String companyComment,
  required double driverRating,
  required String driverComment,
  }) onSubmit;
  final VoidCallback? onCancel;

  const TripRatingDialog({
    super.key,
    this.companyName,
    this.driverName,
    required this.onSubmit,
    this.onCancel,
  });

  @override
  State<TripRatingDialog> createState() => _TripRatingDialogState();
}

class _TripRatingDialogState extends State<TripRatingDialog> {
  double _companyRating = 0;
  double _driverRating = 0;
  final _companyCommentController = TextEditingController();
  final _driverCommentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _companyCommentController.dispose();
    _driverCommentController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_companyRating < 1 || _driverRating < 1) {
      CustomSnackBar.showError('rating_min_error');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await widget.onSubmit(
        companyRating: _companyRating,
        companyComment: _companyCommentController.text.trim(),
        driverRating: _driverRating,
        driverComment: _driverCommentController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pop();
        _navigateToBookingsWithCompletedTab();
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError('something_went_wrong');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleCancel() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
    _navigateToBookingsWithCompletedTab();
  }

  // ✅ دالة التنقل المعدلة بالكامل
  void _navigateToBookingsWithCompletedTab() {
    print('🔵 [_navigateToBookingsWithCompletedTab] STARTED');

    try {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.back();

      Future.delayed(const Duration(milliseconds: 300), () async {
        try {
          if (!Get.isRegistered<MainLayoutController>()) {
            print('❌ MainLayoutController not found');
            return;
          }

          if (!Get.isRegistered<BookingHistoryController>()) {
            Get.put(BookingHistoryController());
          }

          final mainController = Get.find<MainLayoutController>();
          final bookingController = Get.find<BookingHistoryController>();

          final repo = BookingRepository();
          await repo.clearBookingCache();

          await bookingController.fetchBookings();

          bookingController.changeFilter('Completed');

          mainController.bookingStack.assignAll([const BookingHistoryScreen()]);
          mainController.bookingStack.refresh();

          mainController.currentIndex.value = 0;
          mainController.update();

          print('✅ Navigation completed with filter: Completed');
          print('✅ Bookings count: ${bookingController.filteredBookings.length}');

        } catch (e) {
          print('❌ Error during navigation: $e');
        }
      });
    } catch (e) {
      print('❌ Error in _navigateToBookingsWithCompletedTab: $e');
    }
  }

  Widget _ratingSection({
    required String title,
    required String label,
    required double rating,
    required ValueChanged<double> onChanged,
    required TextEditingController commentController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              label + " :",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              " " + title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 8),
        RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          allowHalfRating: false,
          itemCount: 5,
          itemSize: 32,
          glow: false,
          itemPadding: const EdgeInsets.symmetric(horizontal: 2),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: onChanged,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: commentController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'add_comment_hint'.tr,
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'rating_dialog_title'.tr,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              _ratingSection(
                label: "company".tr,
                title: widget.companyName ?? 'company'.tr,
                rating: _companyRating,
                onChanged: (v) => setState(() => _companyRating = v),
                commentController: _companyCommentController,
              ),
              const SizedBox(height: 20),
              _ratingSection(
                label: "driver".tr,
                title: widget.driverName ?? 'driver'.tr,
                rating: _driverRating,
                onChanged: (v) => setState(() => _driverRating = v),
                commentController: _driverCommentController,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _handleCancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'cancel'.tr,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.darkgreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text(
                        'submit_rating_button'.tr,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}