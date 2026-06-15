import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';
import '../../../main_layout/controller/main_layout_controller.dart';
import '../../../subscription_details/controllers/subscription_details_controller.dart';
import '../../../subscription_details/view/screen/subscription_details_screen.dart';
import '../../controllers/subscription_controller.dart';
import '../widget/balance_card.dart';
import '../widget/plan_card.dart';
import '../widget/subscription_info_note.dart';

class SubscriptionScreen extends GetView<SubscriptionController> {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
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
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: AppColor.darkgreen,));
          }

          if (controller.errorMessage.isNotEmpty) {
            return RefreshIndicator(
                color: AppColor.darkgreen,
              onRefresh: () async => await controller.loadPlans(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: Get.height * 0.7,
                  child: Center(child: Text(controller.errorMessage.value)),
                ),
              ),
            );
          }

          return RefreshIndicator(
              color: AppColor.darkgreen,
            onRefresh: () async => await controller.loadPlans(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  SizedBox(height: 10.h),

                  const BalanceCard(),
                  SizedBox(height: 25.h),


                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                    child: Text(
                      "UPGRADE PACKAGES".tr,
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildPlansList(),
                  SizedBox(height: 15.h),

                  const SubscriptionInfoNote(),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildPlansList() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.plans.length,
        itemBuilder: (context, index) {
          final plan = controller.plans[index];
          return PlanCard(
            plan: plan,
            isSelected: controller.selectedPlan.value == plan.name,
            onTap: () {
              controller.selectedPlan.value = plan.name;

              Get.toNamed(
                AppRoute.subscription_details,
                arguments: plan,
              );

              final detailsController = Get.put(SubscriptionDetailsController());
              detailsController.setPlan(plan);
            },
          );
        },
      ),
    );
  }
}
