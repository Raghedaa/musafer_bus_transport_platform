import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../data/models/booking_history_model.dart';
import '../../../controllers/booking_history_controller.dart';
import 'header_widget.dart';
import 'route_widget.dart';
import 'date_time_widget.dart';

class BookingCard extends StatelessWidget {

  final int bookingId;

  const BookingCard({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final BookingHistoryController controller = Get.find<BookingHistoryController>();

    return Obx(() {

      final bool isHighlighted = controller.highlightedBookingId.value == bookingId;

      final index = controller.allBookings.indexWhere((b) => b.id == bookingId);
      if (index == -1) return const SizedBox.shrink();
      final currentBooking = controller.allBookings[index];

      return GestureDetector(
        onTap: () {
          controller.clearHighlight();
          controller.handleBookingTap(context, currentBooking);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: isHighlighted
                ? AppColor.darkgreen.withOpacity(0.8)
                : AppColor.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: isHighlighted ? AppColor.darkgreen : Colors.grey.withOpacity(0.2),
              width: 1.0,
            ),
            boxShadow: isHighlighted
                ? [
              BoxShadow(
                color: AppColor.darkgreen.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 4,
                offset: const Offset(0, 4),
              ),
            ]
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // ⭐ نمرر currentBooking مو booking الأصلي
                HeaderWidget(booking: currentBooking),
                SizedBox(height: 16.h),
                RouteWidget(
                  fromCity: currentBooking.fromCity,
                  toCity: currentBooking.toCity,
                ),
                Divider(height: 32.h, color: Colors.grey.withOpacity(0.4)),
                DateTimeWidget(dateTime: currentBooking.dateTime),
              ],
            ),
          ),
        ),
      );
    });
  }
}