import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_color.dart';

class TicketPnrRow extends StatelessWidget {
  final String pnr;
  const TicketPnrRow({super.key, required this.pnr});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(pnr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.sp)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
              color: AppColor.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10.r)
          ),
          child: Text("CONFIRMED".tr, style: TextStyle(color: Colors.white, fontSize: 10.sp)),
        ),
      ],
    );
  }
}