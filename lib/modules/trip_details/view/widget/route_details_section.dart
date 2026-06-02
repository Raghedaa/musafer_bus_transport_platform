import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/utils/app_formatter.dart';
import '../../../../data/models/trip_model.dart';

class RouteDetailsSection extends StatelessWidget {
  final TripModel trip;
  const RouteDetailsSection({super.key, required this.trip});

  // دالة مساعدة لحساب المدة إذا كانت 00:00
  String _getValidDuration(TripModel trip) {
    if (trip.duration.isNotEmpty && trip.duration != '00:00') {
      return trip.duration;
    }

    try {
      DateTime depDateTime = DateTime.parse(trip.departureTime);
      DateTime arrDateTime = DateTime.parse(trip.arrivalTime);

      Duration diff = arrDateTime.difference(depDateTime);

      if (diff.isNegative) {
        diff = Duration(hours: 24) + diff;
      }

      final hours = diff.inHours;
      final minutes = diff.inMinutes.remainder(60);

      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } catch (e) {
      return '00:00';
    }
  }

  @override
  Widget build(BuildContext context) {
    final depTime = AppFormatter.formatTime(trip.departureTime);
    final arrTime = AppFormatter.formatTime(trip.arrivalTime);
    final displayDuration = _getValidDuration(trip);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Route Details".tr,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
        ),
        SizedBox(height: 10.h),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Departure
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          depTime,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          trip.originCity.tr,
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  /// 🔹 Duration + line
                  Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayDuration,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColor.darkgreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Icon(Icons.circle_outlined, size: 10.sp),
                            Expanded(child: Divider(color: AppColor.darkgreen.withOpacity(0.3), thickness: 1)),
                            Icon(Icons.directions_bus, size: 16.sp, color: AppColor.darkgreen),
                            Expanded(child: Divider(color: AppColor.darkgreen.withOpacity(0.3), thickness: 1)),
                            Icon(Icons.circle, size: 10.sp, color: AppColor.darkgreen),
                          ],
                        ),
                      ],
                    ),
                  ),

                  /// 🔹 Arrival
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          arrTime,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          trip.destinationCity.tr,
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Divider(
                  color: AppColor.grey.withOpacity(0.1),
                  thickness: 1,
                ),
              ),

              Row(
                children: [
                  /// 🔹 Origin Station
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16.sp, color: AppColor.grey),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            trip.originStation?.name ?? "N/A",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColor.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 🔹 Destination Station
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            trip.destinationStation?.name ?? "N/A",                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColor.grey,
                            ),
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.location_on_outlined, size: 16.sp, color: AppColor.grey),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}