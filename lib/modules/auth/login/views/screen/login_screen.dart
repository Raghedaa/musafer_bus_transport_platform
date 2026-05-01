import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/shared/custom_button.dart';
import '../../../sign_up/controllers/signup_controller.dart';
import '../../../sign_up/view/widget/signup_form_card.dart';
import '../../controllers/login_controller.dart';
import '../widget/auth_header.dart';
import '../widget/auth_toggle.dart';
import '../widget/login_footer.dart';
import '../widget/login_form_fields.dart';


class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 60.h),
              const AuthHeader(),
              SizedBox(height: 40.h),
              const AuthToggle(),
              SizedBox(height: 40.h),

              Obx(() => controller.isLogin.value
                  ? _buildLoginForm()
                  : _buildSignUpForm()),

              SizedBox(height: 50.h),
              const LoginFooter(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      children: [
        const LoginFormFields(),
        SizedBox(height: 24.h),
        CustomButton(
            text: "Send Code".tr,
            onPressed: () => controller.login()
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    final signUpController = Get.find<SignUpController>();

    return Column(
      children: [
        const SignUpFormCard(),
        SizedBox(height: 24.h),
        CustomButton(
            text: "Send Code".tr,
            onPressed: () => signUpController.signUp()
        ),
      ],
    );
  }
}