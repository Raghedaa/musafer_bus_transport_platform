import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../controllers/booking_summary_controller.dart';

class PaymentMethodSection extends GetView<BookingSummaryController> {
  const PaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SELECT PAYMENT METHOD".tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
          SizedBox(height: 12.h),

          Obx(
            () => _buildOption(
              title: "Digital Payment".tr,
              subtitle: "VISA, MASTERCARD, WALLET".tr,
              value: 'digital',
              icon: Icons.account_balance_wallet_outlined,
            ),
          ),

          SizedBox(height: 10.h),

          Obx(
            () => _buildOption(
              title: "Cash / Other".tr,
              subtitle: "PAY AT BOARDING STATION".tr,
              value: 'cash',
              icon: Icons.payments_outlined,
            ),
          ),
          // SizedBox(height: 10.h),


        ],
      );
    });
  }

  Widget _buildOption({
    required String title,
    required String subtitle,
    required String value,
    required IconData icon,
  }) {
    bool isSelected = controller.paymentMethod.value == value;

    return GestureDetector(
      onTap: () => controller.changePaymentMethod(value),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.white : AppColor.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColor.primary
                : AppColor.grey.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColor.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: AppColor.primary),
            ),

            SizedBox(width: 12.w),

            // Texts
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: AppColor.black,

                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 10.sp, color: AppColor.black),
                  ),
                ],
              ),
            ),

            // Radio / Check
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColor.primary
                      : AppColor.grey.withOpacity(0.3),
                  width: 2,
                ),
                color: isSelected ? AppColor.primary : AppColor.white,
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 14.sp, color: AppColor.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
