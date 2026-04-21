import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../data/models/booking_summary_model.dart';
import '../../controllers/ticket_controller.dart';

class TicketInfoCard extends StatelessWidget {
  const TicketInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TicketController>();

    final data = controller.ticketData;
    final bool isValid = data is BookingSummaryModel;
    if (data is BookingSummaryModel) {
      print("DEBUG: From: ${data.tripDetails.departureTerminal}, To: ${data.tripDetails.arrivalTime}");
    }
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.darkgreen,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          _buildTopRow(),
          SizedBox(height: 5.h),
          _buildPnrRow(controller.pnr),
          Divider(color: AppColor.white.withOpacity(0.3), height: 30.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLocationColumn(
                  (isValid ? (data.tripDetails.departureTerminal ?? "No City") : "Unknown"),
                  "Departure",
                  isLeft: true
              ),

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
                      (isValid ? (data.tripDetails.departureTime ?? "--:--") : "--:--"),
                      style: TextStyle(color: AppColor.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20.w),

              _buildLocationColumn(
                  (isValid ? (data.tripDetails.arrivalTerminal ?? "No City") : "Unknown"),
                  "Arrival",
                  isLeft: false
              ),
            ],
          ),
          if(isValid) ...[
            SizedBox(height: 15.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Seats: ${data.selectedSeats.join(', ')}",
                style: TextStyle(color: AppColor.white.withOpacity(0.9), fontSize: 12.sp),
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("BOOKING REFERENCE", style: TextStyle(color: AppColor.white.withOpacity(0.8), fontSize: 10.sp)),
        Text("STATUS", style: TextStyle(color: AppColor.white.withOpacity(0.8), fontSize: 10.sp)),
      ],
    );
  }

  Widget _buildPnrRow(String pnr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(pnr, style: TextStyle(color: AppColor.white, fontWeight: FontWeight.bold, fontSize: 18.sp)),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(color: AppColor.white.withOpacity(0.3), borderRadius: BorderRadius.circular(10.r)),
          child: Text("CONFIRMED", style: TextStyle(color: AppColor.white, fontSize: 10.sp)),
        ),
      ],
    );
  }

  Widget _buildLocationColumn(String city, String station, {required bool isLeft}) {
    return Column(
      crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Text(city, style: TextStyle(color: AppColor.white, fontWeight: FontWeight.bold, fontSize: 19.sp)),
        Text(station, style: TextStyle(color: AppColor.white.withOpacity(0.6), fontSize: 11.sp)),
      ],
    );
  }

  Widget _buildTicketDivider() {
    return Expanded(
      child: LayoutBuilder(builder: (context, constraints) {
        final dashCount = (constraints.constrainWidth() / 6).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) => SizedBox(width: 3, height: 1, child: DecoratedBox(decoration: BoxDecoration(color: AppColor.white.withOpacity(0.4))))),
        );
      }),
    );
  }
}