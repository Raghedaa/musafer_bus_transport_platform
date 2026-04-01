import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/modules/search_trip/controllers/search_controller.dart';
import 'package:intl/intl.dart';
import '../../../../../core/utils/app_dialogs.dart';

class DateAndPassengersRow extends GetView<TripSearchController> {
  const DateAndPassengersRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              DateTime? date = await AppPickers.showCustomDatePicker(context);
              if (date != null) {
                controller.updateDateValue(
                  DateFormat('MMM dd, yyyy').format(date),
                );
              }
            },
            child: Obx(
              () => _buildInfo(
                Icons.calendar_today,
                "DEPARTURE",
                controller.departureDate.value,
              ),
            ),
          ),
        ),

        Container(
          width: 1,
          height: 30.h,
          color: AppColor.grey.withOpacity(0.3),
        ),

        SizedBox(width: 20.w),
        Expanded(
          child: InkWell(
            onTap: () {
              AppPickers.showPassengerPicker(
                context: context,
                customController: controller.customPassengerController,
                onSelected: (val) =>
                    controller.updatePassengersValue(val), // تحديث مباشر
              );
            },
            child: Obx(
              () => _buildInfo(
                Icons.group_outlined,
                "PASSENGERS",
                controller.passengers.value,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColor.grey, size: 18.sp),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 10.sp, color: AppColor.grey),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
