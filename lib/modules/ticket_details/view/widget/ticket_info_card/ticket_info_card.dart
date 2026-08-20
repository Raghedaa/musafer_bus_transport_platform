import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../controllers/ticket_controller.dart';

import 'location_column.dart';
import 'ticket_info_header.dart';
import 'ticket_journey_details.dart';
import 'ticket_pnr_code.dart';

class TicketInfoCard extends StatelessWidget {
  const TicketInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketController>(
      builder: (controller) {
        final data = controller.ticketData;

        if (data == null) {
          return const SizedBox();
        }

        final trip = data['trip'];

        if (trip is! Map) {
          return const SizedBox();
        }

        // ✅ قراءة المقاعد من ticketData (الآن ستكون جميع المقاعد المدمجة)
        final rawSeats = data['seat_numbers'];

        final seats = rawSeats is List
            ? rawSeats
            .map((seat) => seat.toString().trim())
            .where((seat) => seat.isNotEmpty)
            .toList()
            : rawSeats == null
            ? <String>[]
            : [rawSeats.toString().trim()];

        // ✅ طباعة للمتابعة
        print('📌 Seats in TicketInfoCard: $seats');

        final departureTime =
            trip['departure_time']?.toString() ?? '';

        final date = departureTime.length >= 10
            ? departureTime.substring(0, 10)
            : '--';

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColor.darkgreen,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              const TicketHeaderRow(),

              SizedBox(height: 5.h),

              TicketPnrRow(
                pnr: controller.pnr,
              ),

              Divider(
                color: Colors.white.withOpacity(0.3),
                height: 30.h,
              ),

              TicketJourneyDetails(
                trip: Map<String, dynamic>.from(trip),
              ),

              SizedBox(height: 15.h),

              TicketSeatInfo(
                seats: seats, // ✅ الآن ستكون [3, 6, 7] أو أي مقاعد مدمجة
                date: date,
              ),
            ],
          ),
        );
      },
    );
  }
}