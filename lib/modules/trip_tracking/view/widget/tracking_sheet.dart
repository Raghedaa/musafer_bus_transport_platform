import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_color.dart';
import 'notification_tile.dart';

class TrackingSheet extends StatelessWidget {
  const TrackingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 0.55.sh, // يغطي جزء من الخريطة
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // السحابة الصغيرة في الأعلى
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10.r)),
              ),
            ),
            SizedBox(height: 25.h),

            // معلومات الرحلة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("CURRENT TRIP", style: TextStyle(color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5.h),
                    Text("Bus #8824 • Route A1", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Est. Arrival", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                    Text("04:45 PM", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),

            SizedBox(height: 15.h),
            // Progress Bar للرحلة
            LinearProgressIndicator(
              value: 0.6,
              backgroundColor: Colors.grey[200],
              color: AppColor.darkgreen,
              minHeight: 6.h,
            ),

            SizedBox(height: 30.h),
            // قسم التنبيهات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Alerts & Notifications", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                Text("Manage", style: TextStyle(color: Colors.grey, fontSize: 13.sp)),
              ],
            ),
            SizedBox(height: 20.h),

            // التنبيهات (إعادة استخدام تصميم الـ Tile)
            const NotificationTile(
              title: "Departure Reminder",
              subtitle: "Your bus is arriving at your stop in 5 minutes.",
              icon: Icons.notifications_active,
              color: Color(0xfffde3d0),
              iconColor: Colors.orange,
              time: "2 mins ago",
            ),
            SizedBox(height: 15.h),
            const NotificationTile(
              title: "Route Update",
              subtitle: "No traffic delays expected on your route today.",
              icon: Icons.info,
              color: Color(0xffe3f2fd),
              iconColor: Colors.blue,
              time: "1 hour ago",
            ),
          ],
        ),
      ),
    );
  }
}