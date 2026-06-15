import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../controllers/promo_controller.dart';
import '../widget/promo_card.dart';

class PromoCodesScreen extends GetView<PromoController> {
  const PromoCodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Promo Codes".tr)),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
              child: CircularProgressIndicator(color: AppColor.darkgreen));
        }
        if (controller.promoList.isEmpty) {
          return Center(
            child: Text(
              "no_promo_codes_available".tr,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.promoList.length,
          itemBuilder: (context, index) =>
              PromoCard(promo: controller.promoList[index]),
        );
      }),
    );
  }
}