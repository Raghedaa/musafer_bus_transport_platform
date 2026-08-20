
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_color.dart';
import '../../core/services/api_service.dart';
import '../../core/shared/custom_snackbar.dart';

class StripeRepository {
  final ApiService _apiService = Get.find<ApiService>();

  Future<Map<String, dynamic>?> createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    try {
      print('🟡 Creating payment intent: $amount $currency');

      final response = await _apiService.post(
        endPoint: 'passenger/wallet/payment-intents',
        data: {
          'amount': amount,
          'currency': currency,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Payment intent created successfully');
        return response.data['data'];
      } else {
        print('❌ Payment intent failed: ${response.data}');
        return null;
      }
    } catch (e) {
      print('❌ Error creating payment intent: $e');
      CustomSnackBar.showError('failed_to_create_payment_intent'.tr);
      return null;
    }
  }

  Future<bool> confirmPayment({
    required String clientSecret,
    required String publishableKey,
  }) async {
    try {
      print('🟡 Configuring Stripe...');

      if (publishableKey.isEmpty) {
        print('❌ Publishable key is empty!');
        CustomSnackBar.showError('payment_config_error'.tr);
        return false;
      }

      Stripe.publishableKey = publishableKey;
      print('✅ Stripe configured');

      print('🟡 Initializing payment sheet...');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Syria Travel',
          style: ThemeMode.light,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: AppColor.darkgreen,
            ),
          ),
          allowsDelayedPaymentMethods: true,
        ),
      );

      print('✅ Payment sheet initialized');

      print('🟡 Presenting payment sheet...');
      await Stripe.instance.presentPaymentSheet();
      print('✅ Payment sheet presented successfully');

      CustomSnackBar.showSuccess('payment_successful'.tr);
      return true;

    } on StripeException catch (e) {
      print('❌ Stripe error: ${e.error.localizedMessage}');
      print('❌ Error code: ${e.error.code}');

      if (e.error.code == FailureCode.Canceled) {
        CustomSnackBar.showError('payment_cancelled'.tr);
      } else {
        CustomSnackBar.showError(
            e.error.localizedMessage ?? 'payment_failed'.tr
        );
      }
      return false;

    } catch (e) {
      print('❌ Payment failed: $e');
      CustomSnackBar.showError('payment_failed'.tr);
      return false;
    }
  }

  Future<Map<String, dynamic>?> getPaymentIntentStatus(String paymentIntentId) async {
    try {
      final response = await _apiService.get(
        endPoint: 'passenger/wallet/payment-intents/$paymentIntentId',
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      print('Error fetching payment status: $e');
      return null;
    }
  }




  // في StripeRepository

  Future<Map<String, dynamic>?> createBookingPaymentIntent({
    required int tripId,
    required List<int> seatNumbers,
    required String paymentMethod, // 'credit_card'
    String? subscriptionId,
  }) async {
    try {
      print('🟡 Creating booking payment intent for trip: $tripId');
      print('🟡 Seats: $seatNumbers');

      final response = await _apiService.post(
        endPoint: 'passenger/bookings',
        data: {
          'trip_id': tripId,
          'seat_numbers': seatNumbers,
          'payment_method': paymentMethod,
          'payment_currency': 'USD',
          if (subscriptionId != null) 'subscription_id': subscriptionId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Booking payment intent created successfully');
        final data = response.data['data'];

        if (data['stripe_checkout'] != null) {
          return {
            'client_secret': data['stripe_checkout']['client_secret'],
            'publishable_key': data['stripe_checkout']['publishable_key'],
            'payment_intent_id': data['stripe_checkout']['payment_intent_id'],
            'booking_id': data['id'],
            'status': data['status'],
            'pnr_code': data['pnr_code'],
          };
        } else {
          return {
            'booking_id': data['id'],
            'status': data['status'],
            'pnr_code': data['pnr_code'],
            'is_instant': true,
          };
        }
      } else {
        print('❌ Booking payment intent failed: ${response.data}');
        return null;
      }
    } catch (e) {
      print('❌ Error creating booking payment intent: $e');
      CustomSnackBar.showError('failed_to_create_booking'.tr);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getBookingStatus(int bookingId) async {
    try {
      final response = await _apiService.get(
        endPoint: 'passenger/bookings/$bookingId',
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      }
      return null;
    } catch (e) {
      print('Error fetching booking status: $e');
      return null;
    }
  }


}