import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../routes/app_routes/app_routes.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/shared/custom_snackbar.dart';
import '../../../../data/repositories/auth_repository.dart';

class LoginController extends GetxController {

  final AuthRepository authRepository;

  LoginController(this.authRepository);

  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var isLogin = true.obs;
  var isLoading = false.obs;

  void login() async {
    if (!formKey.currentState!.validate()) return;

    Get.showOverlay(
      loadingWidget: const Center(
        child: CircularProgressIndicator(color: AppColor.darkgreen),
      ),
      asyncFunction: () async {
        final result = await authRepository.sendLoginOtp(phoneController.text);

        result.fold(
              (error) =>
              CustomSnackBar.show(
                  title: "Alert".tr, message: error, isError: true),
              (success) {
            CustomSnackBar.showSuccess("OTP sent successfully".tr);

            Get.toNamed(AppRoute.verifyEmail, arguments: {
              "phone": phoneController.text,
              "isLogin": true,
            });
          },
        );
      },
    );
  }
}

