
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:musafer/core/constants/app_color.dart';
import '../../../../core/shared/custom_snackbar.dart';
import '../../../../core/shared/management_tile.dart';
import '../../../../data/models/trip_model.dart';
import '../../../main_layout/controller/main_layout_controller.dart';
import '../../../select_seat/controllers/select_seat_controller.dart';
import '../../../select_seat/view/screen/select_seat_screen.dart';
import '../../controllers/ticket_controller.dart';

class BookingManagement extends StatelessWidget {
  const BookingManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TicketController>();
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "BOOKING MANAGEMENT".tr,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.grey,
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 15.h),

          ManagementTile(
            title: "Download Ticket (PDF)".tr,
            subtitle: "Save for offline access".tr,
            icon: Icons.picture_as_pdf,
            iconColor: AppColor.blue,
            iconBgColor: Colors.blue.withOpacity(0.2),
            trailing: Icon(
              Icons.download,
              size: 18.sp,
              color: AppColor.grey.withOpacity(0.6),
            ),
            onTap: () => controller.downloadTicket(),
          ),

          SizedBox(height: 12.h),

          ManagementTile(
            title: "Change Seat".tr,
            subtitle: "Subject to availability".tr,
            icon: Icons.event_seat,
            iconColor: AppColor.teal,
            iconBgColor: AppColor.teal.withOpacity(0.2),
            onTap: () async {
              if (controller.ticketData == null ||
                  controller.tripDetails == null) {
                CustomSnackBar.show(
                  title: 'warning',
                  message: 'incomplete_trip_data',
                  isError: true,
                );
                return;
              }

              final trip = controller.tripDetails!;

              bool hasVehicleData = trip.rawVehicle != null &&
                  trip.rawVehicle.isNotEmpty &&
                  trip.rawSeatMap != null &&
                  trip.rawSeatMap.isNotEmpty;

              if (!hasVehicleData) {
                CustomSnackBar.show(
                  title: 'info',
                  message: 'جاري تحميل بيانات الرحلة...',
                  isError: false,
                );

                try {
                  final freshTrip = await controller.fetchFreshTripData(trip.id);

                  if (freshTrip.rawVehicle.isNotEmpty && freshTrip.rawSeatMap.isNotEmpty) {
                    _navigateToSelectSeat(controller, freshTrip);
                  } else {
                    CustomSnackBar.showError('هذه الرحلة لا تدعم تغيير المقاعد');
                  }
                } catch (e) {
                  CustomSnackBar.showError('حدث خطأ أثناء تحميل بيانات الرحلة');
                }
                return;
              }

              _navigateToSelectSeat(controller, trip);
            },
          ),

          SizedBox(height: 12.h),

          ManagementTile(
            title: "Cancel Booking".tr,
            subtitle: "10% penalty fee applies".tr,
            icon: Icons.cancel,
            iconColor: AppColor.red,
            iconBgColor: AppColor.red.withOpacity(0.1),
            bgColor: AppColor.red.withOpacity(0.05),
            borderColor: AppColor.red.withOpacity(0.2),
            textColor: AppColor.red,
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppColor.red,
            ),
            onTap: () {
              final ticketController = Get.find<TicketController>();

              Get.dialog(
                AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                  title: Text("cancel_booking".tr, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  content: Text("cancel_booking_confirmation".tr),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text("cancel".tr, style: TextStyle(color: Colors.grey)),
                    ),
                    Obx(() => ticketController.isCancelling.value
                        ? CircularProgressIndicator(color: AppColor.darkgreen,)
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColor.red),
                      onPressed: () {
                        Get.back();
                        ticketController.cancelBooking();
                      },
                      child: Text("confirm".tr, style: TextStyle(color: Colors.white)),
                    )),
                  ],
                ),
              );
            },
          ),
        ],
      );
    });
  }

  void _navigateToSelectSeat(TicketController controller, TripModel trip) {
    if (Get.isRegistered<SelectSeatController>()) {
      Get.delete<SelectSeatController>(force: true);
    }

    final seatController = Get.put(SelectSeatController());

    final rawSeats = controller.ticketData!['seat_numbers'];
    List<String> originalSeats = [];

    if (rawSeats is List) {
      originalSeats = rawSeats
          .map((seat) => seat.toString().trim())
          .where((seat) => seat.isNotEmpty)
          .toList();
    } else if (rawSeats != null) {
      originalSeats = [rawSeats.toString().trim()];
    }

    print('ORIGINAL SEATS FROM TICKET: $originalSeats');

    seatController.initWithModifyMode(
      trip: trip,
      bookingId: int.parse(controller.ticketData!['id'].toString()),
      originalSeatsList: originalSeats,
    );

    final layoutController = Get.find<MainLayoutController>();
    layoutController.pushToBookings(const SelectSeatScreen());
  }
}