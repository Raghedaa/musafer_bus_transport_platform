import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import '../../../../data/models/trip_model.dart';

class DriverProfileCard extends StatelessWidget {
  final TripModel trip;
  const DriverProfileCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Trip Details Info".tr, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColor.black)),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(color: AppColor.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              // سطر السائق
              Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: AppColor.primary.withOpacity(0.1),
                    child: Icon(Icons.person, color: AppColor.primary),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trip.driverName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: AppColor.black)),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Icon(Icons.star, size: 14.sp, color: AppColor.amber),
                            Text(" ${trip.driverRating} • ", style: TextStyle(color: AppColor.black, fontSize: 12.sp, fontWeight: FontWeight.w600)),
                            Text("Driver".tr, style: TextStyle(color: AppColor.grey, fontSize: 12.sp)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Divider(color: AppColor.grey.withOpacity(0.1), thickness: 1),
              ),

              Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundColor: AppColor.primary.withOpacity(0.1),
                    child:  Icon(Icons.directions_bus_filled_outlined, color: AppColor.primary),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Vehicle Plate".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp, color: AppColor.grey)),
                        SizedBox(height: 2.h),
                        Text(trip.vehiclePlate, style: TextStyle(color: AppColor.black, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColor.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "${trip.availableSeats} ${"Seats".tr}",
                      style: TextStyle(color: AppColor.black, fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}