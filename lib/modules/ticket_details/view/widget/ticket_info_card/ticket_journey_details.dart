import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/modules/ticket_details/view/widget/ticket_info_card/ticket_info_header.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../data/models/booking_summary_model.dart';
import '../../../controllers/ticket_controller.dart';
import 'location_column.dart';

class TicketJourneyDetails extends StatelessWidget {
  final bool isValid;
  final BookingSummaryModel? data;

  const TicketJourneyDetails({super.key, required this.isValid, this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LocationColumn(
          city: isValid ? (data?.tripDetails.departureTerminal ?? "No City".tr) : "Unknown".tr,
          label: "Departure".tr,
          isLeft: true,
        ),

        Expanded(
          child: Column(
            children: [
              const JourneyDividerWithIcon(),
              SizedBox(height: 4.h),
              Text(
                isValid ? (data?.tripDetails.departureTime ?? "--:--") : "--:--",
                style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(width: 20.w),

        LocationColumn(
          city: isValid ? (data?.tripDetails.arrivalTerminal ?? "No City".tr) : "Unknown".tr,
          label: "Arrival".tr,
          isLeft: false,
        ),
      ],
    );
  }
}