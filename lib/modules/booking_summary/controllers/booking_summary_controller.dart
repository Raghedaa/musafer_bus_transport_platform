import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/shared/custom_snackbar.dart';
import '../../../core/shared/custom_text_form_field.dart';
import '../../../data/models/booking_history_model.dart';
import '../../../data/models/booking_summary_model.dart';
import '../../../data/models/my_subscription_model.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/promo_repository.dart';
import '../../../data/repositories/stripe_repositotrie.dart';
import '../../../data/repositories/trip_repository.dart';
import '../../booking_history/controllers/booking_history_controller.dart';
import '../../booking_history/view/screen/booking_history_screen.dart';
import '../../main_layout/controller/main_layout_controller.dart';
import '../../my_subscriptions/controllers/my_subscriptions_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../../search_trip/view/screen/search_screen.dart';
import '../../subscription/controllers/subscription_controller.dart';
import '../../ticket_details/controllers/ticket_controller.dart';
import '../../ticket_details/view/screen/ticket_details_screen.dart';


class BookingSummaryController extends GetxController {
  final BookingRepository _repository = BookingRepository();
  final TripRepository _tripRepository = TripRepository();
  final PromoRepository _promoRepo = PromoRepository();
  final StripeRepository _stripeRepo = StripeRepository();


  var bookingSummaryModel = Rxn<BookingSummaryModel>();
  var paymentMethod = 'credit_card'.obs;
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
    }
  }


  Future<void> confirmBooking() async {
    if (bookingSummaryModel.value == null) return;

    try {
      isLoading.value = true;
      final model = bookingSummaryModel.value!;
      final seats = model.selectedSeats.map((e) => int.parse(e)).toList();

      int? subscriptionIdToSend;
      if (Get.isRegistered<MySubscriptionsController>()) {
        final subCtrl = Get.find<MySubscriptionsController>();
        final activeSub = subCtrl.subscriptions.firstWhereOrNull((s) => s.status == 'active');
        if (activeSub != null) {
          subscriptionIdToSend = activeSub.id;
        }
      }

      if (paymentMethod.value == 'credit_card') {
        try {
          final bookingIntent = await _stripeRepo.createBookingPaymentIntent(
            tripId: model.tripDetails.id,
            seatNumbers: seats,
            paymentMethod: 'credit_card',
            subscriptionId: subscriptionIdToSend?.toString(),
          );

          if (bookingIntent == null) {
            CustomSnackBar.showError("failed_to_create_booking".tr);
            isLoading.value = false;
            return;
          }

          if (bookingIntent['requires_payment'] == false) {
            pnrNumber.value = bookingIntent['pnr_code'] ?? '';
            CustomSnackBar.showSuccess("booking_confirmed_successfully".tr);
            await _navigateToTicket(bookingIntent);
            isLoading.value = false;
            return;
          }


          final paymentSuccess = await _stripeRepo.confirmPayment(
            clientSecret: bookingIntent['client_secret'],
            publishableKey: bookingIntent['publishable_key'],
          );

          if (!paymentSuccess) {
            isLoading.value = false;
            return;
          }

          final bookingId = bookingIntent['booking_id'];
          bool confirmed = false;
          int attempts = 0;
          const maxAttempts = 15;

          while (attempts < maxAttempts && !confirmed) {
            await Future.delayed(const Duration(seconds: 1));
            attempts++;

            final statusData = await _stripeRepo.getBookingStatus(bookingId);
            if (statusData != null) {
              final status = statusData['status'] as String?;

              if (status == 'confirmed') {
                confirmed = true;
                pnrNumber.value = statusData['pnr_code'] ?? '';
                CustomSnackBar.showSuccess("booking_confirmed_successfully".tr);

                await _navigateToTicket(statusData);

                if (Get.isRegistered<ProfileController>()) {
                  await Get.find<ProfileController>().fetchData();
                }
                break;
              } else if (status == 'cancelled') {
                CustomSnackBar.showError("booking_cancelled_seats_released".tr);
                isLoading.value = false;
                return;
              }
            }
          }

          if (!confirmed) {
            CustomSnackBar.showError("booking_confirmation_timeout".tr);
            isLoading.value = false;
            return;
          }

          isLoading.value = false;
          return;

        } on DioException catch (e) {
          print("❌ Credit Card Booking Error: $e");
          print("❌ Response data: ${e.response?.data}");

          final errorMessage = _extractErrorMessage(e.response?.data);

          if (errorMessage.isNotEmpty) {
            CustomSnackBar.showError(errorMessage);
          } else {
            CustomSnackBar.showError("unexpected_error".tr);
          }

          isLoading.value = false;
          return;
        }
      }

     if (paymentMethod.value == 'wallet') {
        try {
          await _repository.validateBooking(
            tripId: model.tripDetails.id,
            seatNumbers: seats,
            paymentMethod: 'wallet',
            subscriptionId: subscriptionIdToSend,
          );
        } catch (e) {
          if (subscriptionIdToSend != null) {
            subscriptionIdToSend = null;
            await _repository.validateBooking(
              tripId: model.tripDetails.id,
              seatNumbers: seats,
              paymentMethod: 'wallet',
              subscriptionId: null,
            );
          } else {
            rethrow;
          }
        }

        final result = await _repository.createBooking(
          tripId: model.tripDetails.id,
          seatNumbers: seats,
          paymentMethod: 'wallet',
          subscriptionId: subscriptionIdToSend,
        );

        pnrNumber.value = result['pnr_code'] ?? '';
        CustomSnackBar.showSuccess("booking_confirmed_successfully".tr);

        if (Get.isRegistered<ProfileController>()) {
          await Get.find<ProfileController>().fetchData();
        }

        await _navigateToTicket(result);
        isLoading.value = false;
        return;
      }

     if (paymentMethod.value == 'cash') {
        try {
          await _repository.validateBooking(
            tripId: model.tripDetails.id,
            seatNumbers: seats,
            paymentMethod: 'cash',
            subscriptionId: subscriptionIdToSend,
          );
        } catch (e) {
          if (subscriptionIdToSend != null) {
            subscriptionIdToSend = null;
            await _repository.validateBooking(
              tripId: model.tripDetails.id,
              seatNumbers: seats,
              paymentMethod: 'cash',
              subscriptionId: null,
            );
          } else {
            rethrow;
          }
        }

        final result = await _repository.createBooking(
          tripId: model.tripDetails.id,
          seatNumbers: seats,
          paymentMethod: 'cash',
          subscriptionId: subscriptionIdToSend,
        );

        pnrNumber.value = result['pnr_code'] ?? '';
        CustomSnackBar.showSuccess("booking_confirmed_successfully".tr);

        if (Get.isRegistered<ProfileController>()) {
          await Get.find<ProfileController>().fetchData();
        }

        await _navigateToTicket(result);
        isLoading.value = false;
        return;
      }

    } on DioException catch (e) {
      print("❌ Booking Error: $e");

      final errorMessage = _extractErrorMessage(e.response?.data);

      if (errorMessage.isNotEmpty) {
        CustomSnackBar.showError(errorMessage);
      } else {
        CustomSnackBar.showError("unexpected_error".tr);
      }

      isLoading.value = false;

    } catch (e) {
      print("❌ Unexpected error: $e");
      CustomSnackBar.showError("unexpected_error".tr);
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }



  String _extractErrorMessage(dynamic errorData) {
    if (errorData == null) return '';

    try {
      if (errorData is Map) {
        if (errorData['message'] != null) {
          return errorData['message'].toString();
        }

        if (errorData['errors'] != null) {
          final errors = errorData['errors'];
          if (errors is Map) {
            for (var key in errors.keys) {
              final value = errors[key];
              if (value is List && value.isNotEmpty) {
                return value.first.toString();
              } else if (value is String) {
                return value;
              }
            }
          }
        }

        if (errorData['data'] != null && errorData['data'] is Map) {
          return _extractErrorMessage(errorData['data']);
        }
      }

      if (errorData is List && errorData.isNotEmpty) {
        return errorData.first.toString();
      }

      if (errorData is String) {
        return errorData;
      }

    } catch (e) {
      print('❌ Error extracting message: $e');
    }

    return '';
  }

  Future<void> _navigateToTicket(Map<String, dynamic> result) async {
    if (result.containsKey('subscription_id') && result['subscription_id'] != null) {
      result['subscription_id'] = result['subscription_id'].toString();
    }

    final newBooking = BookingHistoryModel.fromJson(result);

    if (Get.isRegistered<BookingHistoryController>()) {
      final historyCtrl = Get.find<BookingHistoryController>();
      historyCtrl.allBookings.insert(0, newBooking);
      historyCtrl.changeFilter(historyCtrl.selectedFilter.value);
      historyCtrl.setHighlightedId(newBooking.id);
    }

    final ticketCtrl = Get.isRegistered<TicketController>()
        ? Get.find<TicketController>()
        : Get.put(TicketController());

    await ticketCtrl.setTripData(result);

    final layoutController = Get.find<MainLayoutController>();

    layoutController.bookingStack.assignAll([
      const BookingHistoryScreen(),
      const TicketDetailsScreen(),
    ]);

    layoutController.currentIndex.value = 0;
    layoutController.update();
    layoutController.bookingStack.refresh();

    layoutController.exploreStack.assignAll([const TripSearchScreen()]);
    layoutController.exploreStack.refresh();
  }


  void updateHistoryLocally(dynamic result) {
    if (Get.isRegistered<BookingHistoryController>()) {
      final historyCtrl = Get.find<BookingHistoryController>();
      final newBooking = BookingHistoryModel.fromJson(result);
      historyCtrl.allBookings.insert(0, newBooking);
      historyCtrl.changeFilter(historyCtrl.selectedFilter.value);
      historyCtrl.setHighlightedId(newBooking.id);
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
        CustomSnackBar.showSuccess("coupon_applied_successfully".tr);
      } else {
        discountAmount.value = 0.0;
        activePromoCode.value = "";
        CustomSnackBar.showError("coupon_not_valid_for_trip".tr);
      }
    } catch (e) {
      String error = e.toString().replaceAll("Exception: ", "");
      if (error.contains("not valid")) {
        CustomSnackBar.showError("coupon_not_valid_for_trip".tr);
      } else {
        CustomSnackBar.showError("error_applying_coupon".tr);
      }
    } finally {
      isApplyingCoupon.value = false;
    }
  }
}