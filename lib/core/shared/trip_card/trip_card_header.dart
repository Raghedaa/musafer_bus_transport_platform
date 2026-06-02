import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../data/models/trip_model.dart';
import '../../utils/app_formatter.dart';

class TripCardHeader extends StatelessWidget {
  final TripModel tripmodel;

  const TripCardHeader({super.key, required this.tripmodel});


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// LEFT
        Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColor.grey.withOpacity(0.2),
              child: Icon(Icons.directions_bus, color: AppColor.primary),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tripmodel.companyName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.star, size: 14.sp, color: AppColor.amber),
                    Text(" ${tripmodel.rating}"),
                  ],
                ),
              ],
            ),
          ],
        ),

        /// RIGHT
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${tripmodel.price} ${"SP".tr}",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
    tripmodel.tripDate,
              // AppFormatter.formatDate(tripmodel.tripDate),
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColor.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}