import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/modules/ticket_details/view/widget/ticket_info_card/ticket_info_header.dart';
import 'package:musafer/modules/ticket_details/view/widget/ticket_info_card/ticket_journey_details.dart';
import 'package:musafer/modules/ticket_details/view/widget/ticket_info_card/ticket_pnr_code.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../data/models/booking_summary_model.dart';
import '../../../../trip_results/controllers/trip_results_controller.dart';
import '../../../controllers/ticket_controller.dart';
import 'location_column.dart';

class TicketInfoCard extends StatelessWidget {
  const TicketInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TicketController>();
    final data = controller.ticketData;
    final bool isValid = data is BookingSummaryModel;
    final tripResultController = Get.find<TripResultsController>();

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
            TicketPnrRow(pnr: controller.pnr),
            Divider(color: AppColor.white.withOpacity(0.3), height: 30.h),

            TicketJourneyDetails(isValid: isValid, data: isValid ? data : null),

            if (isValid) ...[
              SizedBox(height: 15.h),
              TicketSeatInfo(seats: data.selectedSeats, date:  tripResultController.travelDate.value,),
            ],
          ],
        ),
      );
  }
}
