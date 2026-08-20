import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../../../data/models/complaint_details_model.dart';

class InfoCard extends StatelessWidget {
  final ComplaintDetailsModel model;
  const InfoCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration( borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tile(Icons.category, "category".tr, model.categoryName),
          _tile(Icons.description, "description".tr, model.description),

          Divider(color: AppColor.black,),
          _tile(Icons.business, "company".tr, model.companyName),
          _subInfo(["${model.companyEmail}", "${model.companyPhone}", "${model.companyAddress}"]),

          Divider(color: AppColor.black,),
          _tile(Icons.person, "driver".tr, model.driverName),
          _subInfo(["${model.driverUsername}", "${model.driverPhone}"]),

          Divider(color: AppColor.black,),
          _tile(Icons.directions_car, "plate_number".tr, model.plateNumber),
          _tile(Icons.confirmation_number, "booking_code".tr, model.pnrCode),
        ],
      ),
    );
  }

  Widget _subInfo(List<String> details) => Padding(
    padding: EdgeInsets.only(left: 35.w, bottom: 10.h),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:
    details.map((d) => Text(d, style: TextStyle(fontSize: 12.sp, color: AppColor.black))).toList()
    ),
  );

  Widget _tile(IconData icon, String title, String value) => Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(children: [
      Icon(icon, size: 18, color: AppColor.darkgreen),
      SizedBox(width: 8.w),
      Text("$title: ", style: TextStyle(fontWeight: FontWeight.bold,color: AppColor.black)),
      Expanded(child: Text(value,style: TextStyle(color: AppColor.black),)),
    ]),
  );
}