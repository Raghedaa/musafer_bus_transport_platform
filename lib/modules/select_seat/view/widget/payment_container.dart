import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/custom_button.dart';
import '../../controllers/select_seat_controller.dart';
class PaymentContainer extends GetView<SelectSeatController> {
  const PaymentContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final displayPrice = controller.isModifyMode
          ? controller.extraPrice.value
          : controller.totalPrice.value;

      final priceLabel = controller.isModifyMode
          ? "EXTRA AMOUNT".tr
          : "TOTAL PRICE".tr;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(priceLabel, style: TextStyle(color: AppColor.black, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                    Text(
                      "${displayPrice.toStringAsFixed(2)}",
                      style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColor.primary),
                    ),
                  ],
                ),
                Text("${controller.selectedSeats.length} ${"Seats".tr}", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
              ],
            ),
            SizedBox(height: 15.h),
            controller.isSubmitting.value
                ? const Center(child: CircularProgressIndicator(color: AppColor.darkgreen))
                : CustomButton(
              text: controller.isModifyMode
                  ? "confirm_changes".tr
                  : "Proceed to Payment".tr,
              onPressed: () => controller.handleAction(),
            ),
          ],
        ),
      );
    });
  }
}