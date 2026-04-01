import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';

class TripSearchHeader extends StatelessWidget {
  const TripSearchHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Where to?",
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold)),
            Text("Find your next intercity journey",
                style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
          ],
        ),
        CircleAvatar(
          radius: 25.r,
          backgroundColor: Colors.grey[200],
          child: Icon(Icons.person_outline, color: AppColor.black, size: 28.r),
        )
      ],
    );
  }
}