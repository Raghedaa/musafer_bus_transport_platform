import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';

class HeaderWidget extends StatelessWidget {
  final String status;
  final String tripStatus;
  final String pnr;
  const HeaderWidget({super.key, required this.status,required this.tripStatus, required this.pnr});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _buildBadge(status, _getBookingStatusColor(status)),
            SizedBox(width: 6.w),
            _buildBadge(tripStatus, _getTripStatusColor(tripStatus)),
          ],
        ),

        Text(
            "${'PNR'.tr}: $pnr",
            style: TextStyle(fontSize: 12.sp)
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
        label.toUpperCase().tr,
        style: TextStyle(
          color: color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getBookingStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "confirmed": return AppColor.green;
      case "completed": return AppColor.blue;
      case "cancelled": return AppColor.red;
      default: return AppColor.grey;
    }
  }

  Color _getTripStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "scheduled": return Colors.blue;
      case "in_progress": return Colors.orange;
      case "completed": return AppColor.green;
      case "cancelled": return AppColor.red;
      default: return AppColor.grey;
    }
  }

}