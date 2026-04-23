import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';
import '../../controllers/booking_history_controller.dart';
import '../widget/booking_card.dart';
import '../widget/filter_btn.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingHistoryController());

    return Obx((){
      return Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Booking History".tr,
              style: TextStyle(color: AppColor.black, fontWeight: FontWeight.bold, fontSize: 18.sp)),
          backgroundColor: AppColor.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterButton(controller: controller, label: "All"),
                    FilterButton(controller: controller, label: "Upcoming"),
                    FilterButton(controller: controller, label: "Completed"),
                    FilterButton(controller: controller, label: "Cancelled"),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Obx(() {
                  if (controller.filteredBookings.isEmpty) {
                    return Center(
                      child: Text("no_bookings".tr),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.filteredBookings.length,
                    itemBuilder: (context, index) {
                      return BookingCard(booking: controller.filteredBookings[index]);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }

}