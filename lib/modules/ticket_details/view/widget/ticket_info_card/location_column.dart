import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_color.dart';

class LocationColumn extends StatelessWidget {
  final String city;
  final String label;
  final bool isLeft;

  const LocationColumn({required this.city, required this.label, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 10.sp),
        ),
        Text(
          city,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
        ),
      ],
    );
  }
}


class JourneyDividerWithIcon extends StatelessWidget {
  const JourneyDividerWithIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          const _DashedLine(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Icon(Icons.directions_bus, color: Colors.white, size: 20.sp),
          ),
          const _DashedLine(),
        ],
      ),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dashCount = (constraints.constrainWidth() / 6).floor();
          return Flex(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
            children: List.generate(
              dashCount,
              (_) => SizedBox(
                width: 3.w,
                height: 1.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}



class TicketSeatInfo extends StatelessWidget {
  final List<String> seats;
  final String date;

  const TicketSeatInfo({
    super.key,
    required this.seats,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final seatsText = seats.isEmpty
        ? '--'
        : seats.join(', ');

    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
      CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'Seats'.tr,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 11.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              seatsText,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment:
          CrossAxisAlignment.end,
          children: [
            Text(
              'Date'.tr,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 11.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              date,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }
}