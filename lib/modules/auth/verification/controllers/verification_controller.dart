import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/shared/custom_snackbar.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../routes/app_routes/app_routes.dart';

class VerificationController extends GetxController {
  final AuthRepository _authRepository;
  VerificationController(this._authRepository);

  final String phone = Get.arguments?['phone'] ?? "";
  final bool isLogin = Get.arguments?['isLogin'] ?? true;
  final GetStorage _storage = GetStorage();

  var otpLength = 0.obs;
  var secondsRemaining = 40.obs;
  var canResend = false.obs;
  Timer? _timer;

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void startTimer() {
    canResend.value = false;
    secondsRemaining.value = 40;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  String get maskedPhone => phone.length < 10 ? phone : "${phone.substring(0, 4)}******${phone.substring(phone.length - 2)}";

  void onOtpCompleted(String code) => verifyOtp(code);

  void verifyOtp(String code) async {
    if (code.length < 6) return;

    Get.showOverlay(
      asyncFunction: () async {
        final result = isLogin
            ? await _authRepository.loginVerify(phone, code)
            : await _authRepository.registerVerify(phone, code);

        result.fold(
              (error) => CustomSnackBar.show(title: "Error", message: error),
              (successData) => _handleAuthSuccess(successData),
        );
      },
      loadingWidget: const Center(child: CircularProgressIndicator(color: AppColor.darkgreen)),
    );
  }


  void _handleAuthSuccess(Map<String, dynamic> data) {
    String? token = data['access_token'];

    var userData = data['user'];

    if (token != null && token.isNotEmpty) {
      _storage.write("token", token);
      _storage.write("isLoggedIn", true);

      if (userData != null) {
        _storage.write("user_info", userData);
        print("Login Success: Token and User Info saved.");
      }

      Get.offAllNamed(AppRoute.main_layout);
    } else {
      print("Error: access_token missing in response");
      CustomSnackBar.show(title: "Error", message: "Invalid session data");
    }
  }

  Future<void> resendCode() async {
    if (!canResend.value) return;
    final result = await _authRepository.sendLoginOtp(phone);
    result.fold(
          (error) => CustomSnackBar.show(title: "Error", message: error),
          (_) {
        CustomSnackBar.show(title: "Success", message: "OTP sent", isError: false);
        startTimer();
      },
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}