import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../core/shared/custom_snackbar.dart';

class SignUpController extends GetxController {
  final AuthRepository authRepository;
  SignUpController(this.authRepository);

  final phoneController = TextEditingController();
  final fullNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var selectedGender = "male".obs;

  void updateGender(String? val) {
    if (val != null) selectedGender.value = val;
  }


  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    Get.showOverlay(
      loadingWidget: const Center(
        child: CircularProgressIndicator(color: AppColor.darkgreen),
      ),
      asyncFunction: () async {
        final result = await authRepository.registerRequest(
          name: fullNameController.text,
          phone: phoneController.text,
          gender: selectedGender.value,
        );

        result.fold(
              (failureMessage) {
            CustomSnackBar.show(title: "Alert".tr, message: failureMessage,isError: true);
          },
              (successData) {
                CustomSnackBar.showSuccess("otp_sent_success".tr);
                Get.toNamed(AppRoute.verifyEmail, arguments: {
              "phone": phoneController.text,
            });
          },
        );
      },
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    fullNameController.dispose();
    super.onClose();
  }
}