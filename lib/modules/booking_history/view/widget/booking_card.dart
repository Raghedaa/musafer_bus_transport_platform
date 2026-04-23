
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../data/models/booking_history_model.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  const BookingCard({super.key, required this.booking});

  String formatTime(String time) {
    if (Get.locale?.languageCode == 'ar') {
      return time
          .replaceAll("AM", "صباحاً")
          .replaceAll("PM", "مساءً");
    }
    return time;
  }
  
  @override
  Widget build(BuildContext context) {
    return Obx((){
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
                      color: _getStatusColor(booking.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      booking.status.tr,
                      style: TextStyle(
                        color: _getStatusColor(booking.status),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text("${"pnr".tr}: ${booking.pnr}")              ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStation(booking.fromCity, booking.fromStation),
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
                  ),                _buildStation(booking.toCity, booking.toStation, isEnd: true),              ],
              ),
              Divider(height: 32.h, color: Colors.grey.withOpacity(0.4)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14.sp, color: AppColor.grey),
                      SizedBox(width: 6.w),
                      Text(formatTime(booking.dateTime), style: TextStyle(fontSize: 12.sp, color: AppColor.black)),                  ],
                  ),
                  // Text(
                  //   "View Ticket >",
                  //   style: TextStyle(
                  //     color: AppColor.darkgreen,
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 12.sp,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      );
    });
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