import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/shared/custom_button.dart';
import '../../../main_layout/controller/main_layout_controller.dart';
import '../../../ticket_details/controllers/ticket_controller.dart';
import '../../../ticket_details/view/screen/ticket_details_screen.dart';
import '../../controllers/booking_summary_controller.dart';
import '../widget/summary_header.dart';
import '../widget/trip_details_section.dart';
import '../widget/price_breakdown_section.dart';
import '../widget/cancellation_section.dart';
import '../widget/payment_method_section.dart';

class BookingSummaryScreen extends GetView<BookingSummaryController> {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final model = controller.bookingSummaryModel.value;

        if (model == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            const SummaryHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const PNRCardWidget(),
                    SizedBox(height: 20.h),
                    const TripDetailsSection(),
                    SizedBox(height: 20.h),
                    const PriceBreakdownSection(),
                    SizedBox(height: 20.h),
                    const CancellationSection(),
                    SizedBox(height: 20.h),
                    const PaymentMethodSection(),
                    SizedBox(height: 30.h),
                    // داخل BookingSummaryScreen
                    CustomButton(
                      text: "Confirm & Pay".tr,
                      onPressed: () {
                        // Get.offNamed('/ticket_details', id: MainLayoutController.exploreNavId);

                        final currentBookingData = controller.bookingSummaryModel.value;
                        if (currentBookingData != null) {
                          final ticketCtrl = Get.put(TicketController());
                          ticketCtrl.ticketData = currentBookingData;
                          ticketCtrl.update();
                          Get.find<MainLayoutController>().pushToExplore(const TicketDetailsScreen());
                        }
                        },
                    ),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
