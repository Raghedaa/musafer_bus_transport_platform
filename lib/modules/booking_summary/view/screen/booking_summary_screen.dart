import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
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
              child: RefreshIndicator(
                color: AppColor.darkgreen,
                onRefresh: () async {
                  await controller.refreshBookingSummary();
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const TripDetailsSection(),
                      SizedBox(height: 20.h),
                      const PriceBreakdownSection(),
                      SizedBox(height: 20.h),
                      const CancellationSection(),
                      SizedBox(height: 20.h),
                      const PaymentMethodSection(),
                      SizedBox(height: 30.h),
                      CustomButton(
                        text: "Confirm & Pay".tr,
                        isLoading: controller.isLoading.value,
                        onPressed: () async {
                          await controller.confirmBooking();
                        },
                      ),
                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
