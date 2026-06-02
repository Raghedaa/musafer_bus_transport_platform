import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../core/constants/app_color.dart';
import '../../controllers/my_subscriptions_controller.dart';
import 'package:flutter/material.dart';

import '../widget/subscription_item_card.dart';


class MySubscriptionsScreen extends GetView<MySubscriptionsController> {

  const MySubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(title: Text("My Subscriptions".tr), backgroundColor: Colors.transparent, elevation: 0),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator(color: AppColor.primary))
          : controller.subscriptions.isEmpty
          ? Center(child: Text("No active subscriptions".tr))
          : ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: controller.subscriptions.length,
        itemBuilder: (context, index) => SubscriptionItemCard(sub: controller.subscriptions[index]),
      )),
    );
  }
}