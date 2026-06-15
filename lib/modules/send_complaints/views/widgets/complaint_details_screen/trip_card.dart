import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../data/models/complaint_details_model.dart';


class TripCard extends StatelessWidget {
  final ComplaintDetailsModel model;
  const TripCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("trip_info".tr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColor.black)),
          Divider(color: AppColor.black,),
          _tile(Icons.trip_origin, "from".tr, model.originCity),
          _tile(Icons.location_on, "to".tr, model.destinationCity),
          _tile(Icons.access_time, "departure".tr, model.departureTime.substring(0, 16).replaceAll('T', ' ')),
          _tile(Icons.timer, "arrival".tr, model.arrivalTime.substring(0, 16).replaceAll('T', ' ')),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String title, String value) => Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(children: [
      Icon(icon, size: 18, color: AppColor.darkgreen),
      SizedBox(width: 8.w),
      Text("$title: ", style: TextStyle(fontWeight: FontWeight.w600,color: AppColor.black)),
      Text(value,style: TextStyle(color: AppColor.black),),
    ]),
  );
}