import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_color.dart';

class TicketHeaderRow extends StatelessWidget {
  const TicketHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "BOOKING REFERENCE".tr,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10.sp,
            ),
          ),
          Text(
            "STATUS".tr,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10.sp,
            ),
          ),
        ],
      );
  }
}
