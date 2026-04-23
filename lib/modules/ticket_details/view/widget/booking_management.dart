import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:musafer/core/constants/app_color.dart';
import '../../../../core/shared/management_tile.dart';
import '../../controllers/ticket_controller.dart';

class BookingManagement extends StatelessWidget {
  const BookingManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TicketController>();
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "BOOKING MANAGEMENT".tr,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.grey,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 15.h),

          ManagementTile(
            title: "Download Ticket (PDF)".tr,
            subtitle: "Save for offline access".tr,
            icon: Icons.picture_as_pdf,
            iconColor: AppColor.blue,
            iconBgColor: Colors.blue.withOpacity(0.2),
            trailing: Icon(
              Icons.download,
              size: 18.sp,
              color: AppColor.grey.withOpacity(0.6),
            ),
            onTap: () => controller.downloadTicket(),
          ),

          SizedBox(height: 12.h),

          ManagementTile(
            title: "Change Seat".tr,
            subtitle: "Subject to availability".tr,
            icon: Icons.event_seat,
            iconColor: AppColor.teal,
            iconBgColor: AppColor.teal.withOpacity(0.2),
            onTap: () => () {},
          ),

          SizedBox(height: 12.h),

          ManagementTile(
            title: "Cancel Booking".tr,
            subtitle: "10% penalty fee applies".tr,
            icon: Icons.cancel,
            iconColor: AppColor.red.withOpacity(0.5),
            iconBgColor: AppColor.red.withOpacity(0.1),
            bgColor: Colors.red.withOpacity(0.1),
            borderColor: AppColor.red.withOpacity(0.2),
            textColor: AppColor.red.withOpacity(0.5),
            trailing: Icon(
              Icons.info_outline,
              size: 18.sp,
              color: AppColor.red.withOpacity(0.5),
            ),
            onTap: () => () {},
          ),
        ],
      );
    });
  }
}
