import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/modules/ticket_details/view/widget/booking_management.dart';
import '../../../../core/constants/app_color.dart';
import '../../controllers/ticket_controller.dart';
import '../widget/ticket_header.dart';
import '../widget/ticket_info_card/ticket_info_card.dart';
import '../widget/qr_section.dart';

class TicketDetailsScreen extends GetView<TicketController> {
  const TicketDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: AppColor.white,
        body: GetBuilder<TicketController>(
          builder: (controller) {
            return RefreshIndicator(
                color: AppColor.darkgreen,
                onRefresh: () async {
                  await controller.refreshTicketDetails();
                },
                child:Column(
              children: [
                TicketHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        const TicketInfoCard(),
                        SizedBox(height: 20.h),
                        QrSection(pnr: controller.getQrData()),
                        SizedBox(height: 30.h),
                        const BookingManagement(),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ],
                )  );
          },
        ),
      );
    });
  }
}
