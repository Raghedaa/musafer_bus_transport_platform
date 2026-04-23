import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/shared/custom_button.dart';
import '../../controllers/complaints_controller.dart';
import '../widgets/attachment_picker.dart';
import '../widgets/complaint_text_field.dart';
import '../widgets/complaints_app_bar.dart';
import '../widgets/complaints_header.dart';
import '../widgets/ticket_number_field.dart';
import '../widgets/trip_number_field.dart';

class ComplaintsView extends GetView<ComplaintsController> {
  const ComplaintsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: const ComplaintsAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ComplaintsHeader(),
                SizedBox(height: 25.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TripNumberField(controller: controller.tripNumberController),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: TicketNumberField(controller: controller.ticketNumberController),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                ComplaintTextField(controller: controller.complaintController),

                SizedBox(height: 20.h),

                AttachmentsSection(),

                SizedBox(height: 40.h),

                Obx(() => CustomButton(
                  onPressed: controller.sendComplaint,
                  isLoading: controller.isLoading.value,
                  text:"send".tr,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}