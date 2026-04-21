import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/data/models/trip_result_model.dart';

class TripDetailsCard extends StatelessWidget {
  final TripResultModel trip;
  const TripDetailsCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trip.companyName, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColor.amber, size: 16.sp),
                      Text(" ${trip.rating} ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("(${trip.reviewsCount / 1000}k reviews)", style: TextStyle(color: AppColor.grey, fontSize: 12.sp)),
                    ],
                  ),
                ],
              ),
              _buildTag("EXECUTIVE"),
            ],
          ),
          SizedBox(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStationInfo(trip.departureTime, trip.departureTerminal),
              Icon(Icons.directions_bus, color: AppColor.darkgreen, size: 30.sp),
              _buildStationInfo(trip.arrivalTime, trip.arrivalTerminal, isEnd: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStationInfo(String time, String terminal, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment: isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(time, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
        Text(terminal, style: TextStyle(color: AppColor.grey, fontSize: 12.sp)),
      ],
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(color: AppColor.darkgreen.withOpacity(0.1), borderRadius: BorderRadius.circular(8.r)),
      child: Text(label, style: TextStyle(color: AppColor.darkgreen, fontSize: 10.sp, fontWeight: FontWeight.bold)),
    );
  }
}