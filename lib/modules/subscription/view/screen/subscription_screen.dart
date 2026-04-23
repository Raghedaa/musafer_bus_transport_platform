import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import '../../controllers/subscription_controller.dart';
import '../widget/balance_card.dart';
import '../widget/plan_card.dart';
import '../widget/section_label.dart';
import '../widget/upgrade_header.dart';
import '../widget/subscription_info_note.dart';

class SubscriptionScreen extends GetView<SubscriptionController> {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon:  Icon(Icons.arrow_back_ios, color: AppColor.black),
          //   onPressed: () => Get.back(),
          // ),
          title: Text(
            "Subscription Module".tr,
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              const SectionLabel(label: "ACTIVE BALANCE"),
              SizedBox(height: 10.h),

              const BalanceCard(),
              SizedBox(height: 25.h),

              const UpgradeHeader(),
              SizedBox(height: 15.h),

              _buildPlansList(),
              SizedBox(height: 15.h),

              const SubscriptionInfoNote(),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildPlansList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.plans.length,
      itemBuilder: (context, index) {
        final plan = controller.plans[index];
        return Obx(
          () => PlanCard(
            plan: plan,
            isSelected: controller.selectedPlan.value == plan.title,
            onTap: () => controller.selectedPlan.value = plan.title,
          ),
        );
      },
    );
  }
}
