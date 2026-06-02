import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../data/models/trip_model.dart';
import '../../utils/app_formatter.dart';

class TripCardTimeLine extends StatelessWidget {
  final TripModel tripResultModel;

  const TripCardTimeLine({super.key, required this.tripResultModel});

  @override
  Widget build(BuildContext context) {
    print(tripResultModel.duration);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTimeInfo(
          AppFormatter.formatTime(tripResultModel.departureTime),
          tripResultModel.originCity,
          false,
        ),

        Expanded(
          child: Column(
            children: [

              Row(
                children: [
                  Icon(Icons.circle_outlined, size: 10.sp),
                  Expanded(child: Divider()),
                  Icon(Icons.directions_bus, size: 16.sp),
                  Expanded(child: Divider()),
                  Icon(Icons.circle, size: 10.sp),

                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w,),

        _buildTimeInfo(
          AppFormatter.formatTime(tripResultModel.arrivalTime),
          tripResultModel.destinationCity,
          true,
        ),
      ],
    );
  }

  Widget _buildTimeInfo(String time, String city, bool isEnd) {
    return Column(
      crossAxisAlignment:
      isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(time, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(city.tr),
      ],
    );
  }
}