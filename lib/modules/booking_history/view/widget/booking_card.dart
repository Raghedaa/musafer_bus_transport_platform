import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_color.dart';

class BookingCard extends StatelessWidget {
  final String status;
  const BookingCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(status),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text("PNR: #BX8291", style: TextStyle(color: AppColor.grey, fontSize: 11.sp)),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStation("Beirut", "Charles Helou"),
                Icon(Icons.directions_bus, color: AppColor.darkgreen, size: 22.sp),
                _buildStation("Tripoli", "Al Nour Square", isEnd: true),
              ],
            ),
            Divider(height: 32.h, color: Colors.grey.withOpacity(0.1)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 14.sp, color: AppColor.grey),
                    SizedBox(width: 6.w),
                    Text("Oct 24, 08:30 AM", style: TextStyle(fontSize: 12.sp, color: AppColor.black)),
                  ],
                ),
                Text(
                  "View Ticket >",
                  style: TextStyle(
                    color: AppColor.darkgreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStation(String city, String station, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment: isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(city, style: TextStyle(color: AppColor.grey, fontSize: 11.sp)),
        SizedBox(height: 4.h),
        Text(station, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: AppColor.black)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Upcoming": return AppColor.green;
      case "Completed": return AppColor.blue;
      case "Cancelled": return AppColor.red;
      default: return AppColor.grey;
    }
  }
}