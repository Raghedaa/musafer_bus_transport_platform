import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/shared/custom_snackbar.dart';
import '../../../core/shared/custom_text_form_field.dart';
import '../../../data/models/booking_summary_model.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/promo_repository.dart';
import '../../../data/repositories/trip_repository.dart';
import '../../main_layout/controller/main_layout_controller.dart';
import '../../ticket_details/controllers/ticket_controller.dart';
import '../../ticket_details/view/screen/ticket_details_screen.dart';
import 'package:flutter/material.dart';

class BookingSummaryController extends GetxController {


  final BookingRepository _repository = BookingRepository();
  final TripRepository _tripRepository = TripRepository();
  final PromoRepository _promoRepo = PromoRepository();

  var bookingSummaryModel = Rxn<BookingSummaryModel>();
  var paymentMethod = 'digital'.obs;
  var isLoading = false.obs;
  var pnrNumber = "".obs;

  final TextEditingController couponCode = TextEditingController();
  var discountAmount = 0.0.obs;
  var isApplyingCoupon = false.obs;
  var activePromoCode = "".obs;

  @override
  void onClose() {
    couponCode.dispose();
    super.onClose();
  }
  void changePaymentMethod(String method) => paymentMethod.value = method;


  Future<void> refreshBookingSummary() async {
    if (bookingSummaryModel.value == null) return;

    try {
      final updatedTrip = await _tripRepository.fetchTripDetails(
          bookingSummaryModel.value!.tripDetails.id
      );

      final oldModel = bookingSummaryModel.value!;
      bookingSummaryModel.value = BookingSummaryModel(
        tripDetails: updatedTrip,
        selectedSeats: oldModel.selectedSeats,
        pnrNumber: oldModel.pnrNumber,
        totalPrice: oldModel.totalPrice,
        bookingDate: oldModel.bookingDate,
      );

    } catch (e) {
      print("Refresh Error: $e");
      // CustomSnackBar.showError("failed_refresh_booking".tr);
      }
  }


  Future<void> confirmBooking() async {
    if (bookingSummaryModel.value == null) return;

    try {
      isLoading.value = true;
      final model = bookingSummaryModel.value!;

      final result = await _repository.createBooking(
        tripId: model.tripDetails.id,
        seatNumbers: model.selectedSeats.map((e) => int.parse(e)).toList(),
        paymentMethod: paymentMethod.value,
      );


      pnrNumber.value = result['pnr_code'] ?? '';
      CustomSnackBar.showSuccess("booking_confirmed_successfully".tr);
      final ticketCtrl = Get.isRegistered<TicketController>()
          ? Get.find<TicketController>()
          : Get.put(TicketController());

      await ticketCtrl.setTripData(result);

      Get.find<MainLayoutController>().pushToExplore(const TicketDetailsScreen());

    } catch (e) {
      print("Booking error: $e");
      CustomSnackBar.showError("something_went_wrong".tr);    } finally {
      isLoading.value = false;
    }
  }


  void showCouponDialog() {
    couponCode.text = "";

    Get.defaultDialog(
      title: "Apply Coupon".tr,
      content: Column(
        children: [
          CustomTextFormField(
            hint: "Enter coupon code".tr,
            controller: couponCode,
          ),
          SizedBox(height: 15.h),
          Obx(() => isApplyingCoupon.value
              ? const CircularProgressIndicator(color: AppColor.darkgreen)
              : ElevatedButton(
            onPressed: () async {
              await applyCoupon(couponCode.text);

              if (discountAmount.value > 0) {
                Get.back();
              }
            },
            child: Text("Apply".tr),
          )),
        ],
      ),
    );
  }

  Future<void> applyCoupon(String code) async {
    if (code.isEmpty) return;

    isApplyingCoupon.value = true;
    try {
      final tripId = bookingSummaryModel.value!.tripDetails.id;
      final result = await _promoRepo.validatePromoCode(code, tripId);

      if (result != null) {
        discountAmount.value = (result['discount_amount'] as num).toDouble();
        activePromoCode.value = code;

        CustomSnackBar.showSuccess("Coupon applied successfully!".tr);
      } else {
        discountAmount.value = 0.0;
        activePromoCode.value = "";
        CustomSnackBar.showError("Invalid coupon code".tr);
      }
    } catch (e) {
      CustomSnackBar.showError("Error applying coupon".tr);
    } finally {
      isApplyingCoupon.value = false;
    }
  }
}