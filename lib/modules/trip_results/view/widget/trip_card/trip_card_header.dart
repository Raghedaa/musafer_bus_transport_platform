import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/data/models/trip_result_model.dart';

class TripCardHeader extends StatelessWidget {
  final TripResultModel tripResultModel;

  const TripCardHeader({super.key, required this.tripResultModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: AppColor.grey.withOpacity(0.2),
              child: Icon(
                Icons.directions_bus,
                color: AppColor.primary,
                size: 22.sp,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tripResultModel.companyName,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                      color: AppColor.black
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: AppColor.amber, size: 14.sp),
                    Text(
                      " ${tripResultModel.rating}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " (${tripResultModel.reviewsCount > 1000 ? (tripResultModel.reviewsCount / 1000).toStringAsFixed(1) + 'k' : tripResultModel.reviewsCount} reviews)",
                      style: TextStyle(fontSize: 11.sp, color: AppColor.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "\$${tripResultModel.price.toInt()}",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            Text(
              "PER SEAT".tr,
              style: TextStyle(fontSize: 10.sp, color: AppColor.grey),
            ),
          ],
        ),
      ],
    );
  }
}
