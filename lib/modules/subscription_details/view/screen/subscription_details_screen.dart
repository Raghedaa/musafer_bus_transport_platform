import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import 'package:flutter/material.dart';
import '../../../main_layout/controller/main_layout_controller.dart';
import '../../controllers/subscription_details_controller.dart';

class SubscriptionDetailsScreen extends StatelessWidget {
  const SubscriptionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SubscriptionDetailsController());

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        title: Text("Plan Details".tr),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: AppColor.black),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        if (controller.plan.value == null)
          return const Center(child: CircularProgressIndicator(color: AppColor.darkgreen,));
        final plan = controller.plan.value!;

        return ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            // القسم العام
            _buildSectionTitle("General Info".tr),
            _buildCard([
              _buildDetailRow("Type".tr, plan.type.tr),
              _buildDetailRow("Price".tr, "${plan.price} ${'SP'.tr}"),
              _buildDetailRow(
                  "Validity".tr, "${plan.validityDays} " + "Days".tr),
              _buildDetailRow("Total Trips".tr, "${plan.totalTrips}"),
            ]),

            // قسم الشروط
            _buildSectionTitle("Conditions".tr),
            _buildCard([
              _buildDetailRow("Max Tickets/Trip".tr,
                  "${plan.conditions['max_tickets_per_trip'] ?? 1}"),
            ]),

            // قسم الشركة
            _buildSectionTitle("Company Info".tr),
            _buildCard([
              _buildDetailRow("Company".tr, plan.companyName),
              _buildDetailRow("Rating".tr, plan.companyRating, icon: Icons.star,
                  iconColor: AppColor.amber),
              _buildDetailRow("Phone".tr, plan.companyPhone, icon: Icons.phone),
            ]),

            SizedBox(height: 20.h),

            ElevatedButton(
              onPressed: controller.isSubscribing.value
                  ? null
                  : () => controller.subscribe(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.darkgreen,
                  padding: EdgeInsets.symmetric(vertical: 15.h)),
              child: controller.isSubscribing.value
                  ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(
                "Subscribe Now".tr,
                style: const TextStyle(color: Colors.white),
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) =>
      Padding(
        padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
        child: Text(title, style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color:  AppColor.black)),
      );

  Widget _buildCard(List<Widget> children) =>
      Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(color: AppColor.cardColor,
            borderRadius: BorderRadius.circular(15.r)),
        child: Column(children: children),
      );

  Widget _buildDetailRow(String title, String value,
      {IconData? icon, Color? iconColor}) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            if (icon != null) Icon(
                icon, size: 18.sp, color: iconColor ?? AppColor.darkgreen),
            if (icon != null) SizedBox(width: 8.w),
            Text(title, style: TextStyle(color: AppColor.grey)),
            const Spacer(),
            Text(value, style: TextStyle(
                fontWeight: FontWeight.bold, color: AppColor.black)),
          ],
        ),
      );
}