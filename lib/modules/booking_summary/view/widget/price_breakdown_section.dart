import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../controllers/booking_summary_controller.dart';

class PriceBreakdownSection extends GetView<BookingSummaryController> {
  const PriceBreakdownSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final model = controller.bookingSummaryModel.value;
      if (model == null) return const SizedBox();

      final ticketPrice = model.tripDetails.price;
      final seatsCount = model.selectedSeats.length;
      final totalTicketPrice = ticketPrice * seatsCount;
      final finalPrice = totalTicketPrice - controller.discountAmount.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PRICE BREAKDOWN".tr,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
          SizedBox(height: 10.h),

          _priceRow("Ticket x$seatsCount".tr, "$totalTicketPrice", currency: "SP".tr),
          _priceRow("Service Fee".tr, "0", currency: "SP".tr),


          _priceRowWithCoupon(
              controller.activePromoCode.value.isEmpty
                  ? "Apply Coupon".tr
                  : "${"Discount".tr} (${controller.activePromoCode.value})",
              "${controller.discountAmount.value}",
              currency: "SP".tr,
              isDiscount: true
          ),

          const Divider(),

          _priceRow("Total Amount".tr, "$finalPrice",
              currency: "SP".tr, isTotal: true, fontSize: 16.sp),
        ],
      );
    });
  }

  Widget _priceRowWithCoupon(String title, String price, {required String currency, bool isDiscount = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => controller.showCouponDialog(),
            child: Row(
              children: [
                Text(title, style: TextStyle(color: AppColor.black, fontWeight: FontWeight.w600)),
                SizedBox(width: 8.w),
                Icon(Icons.add_circle_outline, size: 18.sp, color: AppColor.primary),
              ],
            ),
          ),
          Text("- $price $currency",
              style: TextStyle(color: isDiscount ? AppColor.green : AppColor.black, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _priceRow(String title, String price,
      {required String currency, bool isDiscount = false, bool isTotal = false, double? fontSize}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  color: isDiscount ? AppColor.green : AppColor.black,
                  fontSize: fontSize,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text("$price $currency",
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                  color: isDiscount ? AppColor.green : AppColor.black,
                  fontSize: fontSize)),
        ],
      ),
    );
  }
}