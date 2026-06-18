import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../core/utils/app_formatter.dart';
class DateTimeWidget extends StatelessWidget {
  final String dateTime;
  const DateTimeWidget({super.key, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    // final formattedDate = AppFormatter.formatDate(dateTime);
    // final formattedTime = AppFormatter.formatTime(dateTime);

    final dt = DateTime.parse(dateTime);
    final formattedDate = "${dt.day}/${dt.month}/${dt.year}";
    final formattedTime = AppFormatter.formatTime(dateTime);
    return Row(

      children: [
        Text(
          formattedDate,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
        ),

        const Spacer(),
        Row(
          children: [
            Icon(Icons.access_time, size: 14.sp, color: AppColor.grey),
            SizedBox(width: 6.w),
            Text(
              formattedTime,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}