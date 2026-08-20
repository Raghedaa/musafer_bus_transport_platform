import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/shared/custom_button.dart';
import '../../../../core/shared/custom_text_form_field.dart';
import '../../controllers/complaints_controller.dart';
import '../widgets/my_complaints/category_selector.dart';
import '../widgets/send_complaint/complaint_attachment_widget.dart';
import '../widgets/send_complaint/complaints_app_bar.dart';
import '../widgets/send_complaint/complaints_header.dart';

class SendComplaintsScreen extends GetView<ComplaintsController> {
  const SendComplaintsScreen({super.key});

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
                SizedBox(height: 16.h),

                _InfoRow(label: 'Trip Number'.tr, value: '${controller.tripId}'),
                SizedBox(height: 12.h),
                _InfoRow(label: 'Booking Number'.tr, value: '${controller.bookingId}'),
                SizedBox(height: 24.h),

                const CategorySelector(),
                SizedBox(height: 20.h),

                // وصف الشكوى
                _FieldLabel('writeYourComplaint'.tr),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  controller: controller.descriptionController,
                  hint: 'writeYourComplaint'.tr,
                  maxLines: 7,
                  keyboardType: TextInputType.multiline,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please write something first'.tr
                      : null,
                ),

                SizedBox(height: 16.h),

                const ComplaintAttachmentWidget(),

                SizedBox(height: 40.h),

                Obx(() => CustomButton(
                  onPressed: controller.sendComplaint,
                  isLoading: controller.isLoading.value,
                  text: 'send'.tr,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColor.cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.grey.withOpacity(0.2)),
            ),
            child: Text(value, style: TextStyle(fontSize: 13.sp)),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColor.black),
    );
  }
}