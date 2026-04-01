import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../core/constants/app_color.dart';
import '../../controllers/booking_summary_controller.dart';

class PriceBreakdownSection extends GetView<BookingSummaryController> {
  const PriceBreakdownSection({super.key});

  @override
  @override
  Widget build(BuildContext context) {

    final model = controller.bookingSummaryModel.value;
    // إذا كانت البيانات لم تصل بعد
    if (model == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("PRICE BREAKDOWN", style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.grey)),
        SizedBox(height: 10.h),
        // عرض سعر التذكرة الواحدة × عدد الكراسي
        _priceRow(
            "Ticket x${model.selectedSeats.length}",
            "\$${(model.tripDetails.price * model.selectedSeats.length).toStringAsFixed(2)}"
        ),
        _priceRow("Service Fee", "\$0.00"), // عدلها حسب منطق تطبيقك
        _priceRow("Discount", "-\$0.00", isDiscount: true),
        const Divider(),
        _priceRow(
            "Total Amount",
            "\$${model.totalPrice.toStringAsFixed(2)}",
            isTotal: true,
            fontSize: 16.sp
        ),
      ],
    );
  }

  Widget _priceRow(
      String title,
      String price, {
        bool isDiscount = false,
        bool isTotal = false,
        double? fontSize,
      }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDiscount ? AppColor.green : AppColor.black,
              fontSize: fontSize,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? AppColor.green : AppColor.black,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}