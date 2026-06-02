import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../core/utils/app_formatter.dart';
import '../../controllers/booking_summary_controller.dart';

class TripDetailsSection extends GetView<BookingSummaryController> {
  const TripDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final booking = controller.bookingSummaryModel.value;
      if (booking == null) return const SizedBox.shrink();

      final trip = booking.tripDetails;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("TRIP DETAILS".tr, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10.h),
          Card(
            color: AppColor.grey.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(trip.originCity.tr),
                        Text(AppFormatter.formatTime(trip.departureTime)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(AppFormatter.formatDuration(trip.duration)),
                      Icon(Icons.directions_bus),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(trip.destinationCity.tr),
                        Text(AppFormatter.formatTime(trip.arrivalTime)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}