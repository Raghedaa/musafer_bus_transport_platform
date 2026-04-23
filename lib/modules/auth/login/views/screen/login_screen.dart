import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/shared/custom_button.dart';
import '../../../../../routes/app_routes/app_routes.dart';
import '../../../sign_up/view/widget/signup_form_card.dart';
import '../../controllers/login_controller.dart';
import '../widget/auth_header.dart';
import '../widget/auth_toggle.dart';
import '../widget/social_login.dart';
import '../widget/login_form_fields.dart';
import '../widget/remember_me_section.dart';
import '../widget/login_footer.dart';


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
              SizedBox(height: 40.h),
              const AuthHeader(),
              SizedBox(height: 30.h),
              const AuthToggle(),
              SizedBox(height: 30.h),

              Obx(() => controller.isLogin.value
                  ? _buildLoginForm()
                  : const SignUpFormCard()
              ),

              SizedBox(height: 30.h),
              const SocialLogin(),
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
        const RememberMeSection(),
        SizedBox(height: 20.h),
        CustomButton(text: "Login".tr, onPressed: () => controller.login()),
      ],
    );
  }
}
