import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';

class RouteWidget extends StatelessWidget {
  final String fromCity;
  final String toCity;
  const RouteWidget({super.key, required this.fromCity, required this.toCity});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "from".tr,
                style: TextStyle(fontSize: 10.sp, color: Colors.grey),
              ),
              SizedBox(height: 4.h),
              Text(
                fromCity,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
            ],
          ),
        ),
        // خط السير
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Icon(Icons.circle_outlined, size: 10.sp),
              Expanded(child: Divider(thickness: 1, color: Colors.grey.withOpacity(0.5))),
              Icon(Icons.directions_bus, size: 16.sp, color: AppColor.darkgreen),
              Expanded(child: Divider(thickness: 1, color: Colors.grey.withOpacity(0.5))),
              Icon(Icons.circle, size: 10.sp, color: AppColor.darkgreen),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "to".tr,
                style: TextStyle(fontSize: 10.sp, color: Colors.grey),
              ),
              SizedBox(height: 4.h),
              Text(
                toCity,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}