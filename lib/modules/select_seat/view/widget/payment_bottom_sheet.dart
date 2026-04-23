import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/shared/custom_button.dart';
import '../../controllers/select_seat_controller.dart';

class PaymentBottomSheet extends GetView<SelectSeatController> {
  const PaymentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TOTAL PRICE".tr,
                      style: TextStyle(color: AppColor.black, fontSize: 12.sp,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${controller.totalPrice.value.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                  ],
                ),

                Text(
                  "${controller.selectedSeats.length} " + "Seats".tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            CustomButton(
              text: "Proceed to Payment".tr,
              onPressed: () => controller.goToPayment(),
            ),
          ],
        ),
      );
    });
  }
}
