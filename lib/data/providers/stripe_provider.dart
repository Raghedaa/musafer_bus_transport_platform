import 'package:flutter/material.dart';

import '../repositories/stripe_repositotrie.dart';

class StripeProvider extends ChangeNotifier {
  final StripeRepository _repository = StripeRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> topUpWalletWithStripe({
    required double amount,
    required String currency,
    required Function(Map<String, dynamic> walletData) onSuccess,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. إنشاء Payment Intent
      final paymentIntent = await _repository.createPaymentIntent(
        amount: amount,
        currency: currency,
      );

      if (paymentIntent == null) {
        _errorMessage = 'Failed to create payment intent';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final success = await _repository.confirmPayment(
        clientSecret: paymentIntent['client_secret'],
        publishableKey: paymentIntent['publishable_key'],
      );

      if (success) {

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Payment failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}