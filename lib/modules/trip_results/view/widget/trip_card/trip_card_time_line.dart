import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/data/models/trip_result_model.dart';

class TripCardTimeLine extends StatelessWidget {
  final TripResultModel tripResultModel;

  const TripCardTimeLine({super.key, required this.tripResultModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTimeInfo(
          tripResultModel.departureTime,
          tripResultModel.departureTerminal,
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                Icon(Icons.circle_outlined, size: 12.sp, color: AppColor.grey),
                Expanded(
                  child: Divider(
                    color: AppColor.grey.withOpacity(0.3),
                    thickness: 1,
                  ),
                ),
                Icon(
                  Icons.directions_bus,
                  size: 16.sp,
                  color: AppColor.darkgreen,
                ),
                Expanded(
                  child: Divider(
                    color: AppColor.grey.withOpacity(0.3),
                    thickness: 1,
                  ),
                ),
                Icon(Icons.circle, size: 12.sp, color: AppColor.grey),
              ],
            ),
          ),
        ),
        _buildTimeInfo(
          tripResultModel.arrivalTime,
          tripResultModel.arrivalTerminal,
        ),
      ],
    );
  }

  Widget _buildTimeInfo(String time, String terminal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          terminal,
          style: TextStyle(fontSize: 12.sp, color: AppColor.grey),
        ),
      ],
    );
  }
}
