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
    final controller = Get.put(TicketController());

    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "BOOKING MANAGEMENT",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.grey.withOpacity(0.3),
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 15.h),

          ManagementTile(
            title: "Download Ticket (PDF)",
            subtitle: "Save for offline access",
            icon: Icons.picture_as_pdf,
            iconColor: AppColor.blue,
            iconBgColor: Colors.blue.withOpacity(0.2),
            trailing: Icon(Icons.download, size: 18.sp, color: AppColor.grey.withOpacity(0.6)),
            onTap: () => controller.downloadTicket(),
          ),

          SizedBox(height: 12.h),

          ManagementTile(
            title: "Change Seat",
            subtitle: "Subject to availability",
            icon: Icons.event_seat,
            iconColor: AppColor.teal,
            iconBgColor: AppColor.teal.withOpacity(0.2),
            onTap: () => (){},
          ),

          SizedBox(height: 12.h),

          ManagementTile(
            title: "Cancel Booking",
            subtitle: "10% penalty fee applies",
            icon: Icons.cancel,
            iconColor: AppColor.red,
            iconBgColor: AppColor.red.withOpacity(0.1),
            bgColor: Colors.red.shade50.withOpacity(0.3),
            borderColor: AppColor.red.withOpacity(0.2),
            textColor: AppColor.red,
            trailing: Icon(Icons.info_outline, size: 18.sp, color: AppColor.red),
            onTap: () => (){},
          ),
        ],
      );
  }
}