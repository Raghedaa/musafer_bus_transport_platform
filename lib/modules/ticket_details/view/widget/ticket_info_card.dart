import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';

class TicketInfoCard extends StatelessWidget {
  const TicketInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.darkgreen,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "BOOKING REFERENCE",
                style: TextStyle(
                  color: AppColor.white.withOpacity(0.8),
                  fontSize: 10.sp,
                ),
              ),
              Text(
                "Status",
                style: TextStyle(
                  color: AppColor.white.withOpacity(0.8),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "PNR-7724X9",
                  style: TextStyle(
                    color: AppColor.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColor.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  "CONFIRMED",
                  style: TextStyle(color: AppColor.white, fontSize: 10.sp),
                ),
              ),
            ],
          ),

          Divider(color: AppColor.white.withOpacity(0.3), height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLocationColumn("Cairo", "Tahrir Sq. Station", isLeft: true),

              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildTicketDivider(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Icon(Icons.directions_bus, color: AppColor.white, size: 24.sp),
                        ),
                        _buildTicketDivider(),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "3H 30M",
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20.w,),

              _buildLocationColumn("Alex", "Sidi Gaber", isLeft: false),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildTicketDivider() {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 3.0;
          const dashHeight = 1.0; 
          final dashCount = (boxWidth / (2 * dashWidth)).floor();

          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColor.white.withOpacity(0.4), 
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
  Widget _buildLocationColumn(String city, String station, {required bool isLeft}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          city,
          style: TextStyle(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        Text(
          station,
          style: TextStyle(color: AppColor.white.withOpacity(0.6), fontSize: 12.sp),
        ),
      ],
    );
  }
}
