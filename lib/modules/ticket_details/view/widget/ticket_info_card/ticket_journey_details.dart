import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';

import '../../../../../core/utils/app_formatter.dart';

class TicketJourneyDetails extends StatelessWidget {
  final Map<String, dynamic> trip;

  const TicketJourneyDetails({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    String depTime = AppFormatter.formatTime(trip['departure_time']);
    String arrTime = AppFormatter.formatTime(trip['estimated_arrival_time']);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              trip['origin_city']['name'],
              style: TextStyle(
                color: AppColor.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              depTime,
              style: TextStyle(
                color: AppColor.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Icon(Icons.directions_bus, color: AppColor.white),
        Column(
          children: [
            Text(
              trip['destination_city']['name'],
              style: TextStyle(
                color: AppColor.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              arrTime,
              style: TextStyle(
                color: AppColor.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
