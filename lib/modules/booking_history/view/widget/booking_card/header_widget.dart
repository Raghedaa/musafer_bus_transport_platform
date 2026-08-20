import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../data/models/booking_history_model.dart';

class HeaderWidget extends StatelessWidget {
  final BookingHistoryModel booking;
  const HeaderWidget({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final String statusText = _getTranslatedStatus(booking.tripStatus);
    final Color statusColor = _getTripStatusColor(booking.tripStatus);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBadge(statusText, statusColor),
        Text(
          "${'PNR'.tr}: ${booking.pnr}",
          style: TextStyle(fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getTranslatedStatus(String status) {
    final String lowerStatus = status.toLowerCase();
    switch (lowerStatus) {
      case "scheduled":
        return 'scheduled'.tr;
      case "in_progress":
      case "inprogress":
        return 'in_progress'.tr;
      case "completed":
        return 'completed'.tr;
      case "cancelled":
        return 'cancelled'.tr;
      case "confirmed":
        return 'confirmed'.tr;
      case "pending":
        return 'pending'.tr;
      default:
        return status.toUpperCase().tr;
    }
  }

  Color _getTripStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "scheduled":
        return Colors.blue;
      case "in_progress":
      case "inprogress":
        return Colors.orange;
      case "completed":
        return AppColor.green;
      case "cancelled":
        return AppColor.red;
      case "confirmed":
        return Colors.green;
      case "pending":
        return Colors.grey;
      default:
        return AppColor.grey;
    }
  }
}