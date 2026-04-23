import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/core/constants/app_image.dart';
import 'package:musafer/core/shared/custom_social_button.dart';

import '../../controllers/login_controller.dart';

class SocialLogin extends GetView<LoginController> {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                "OR CONTINUE WITH".tr,
                style: TextStyle(fontSize: 10.sp, color: AppColor.primaryGrey),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: CustomSocialButton(
                label: "Google".tr,
                onPressed: () => {},
                    // controller.signInWithGoogle(),
                customIcon: SvgPicture.asset(
                  AppImageAsset.google_logo,
                  height: 18.sp,
                ),
              ),
            ),
            SizedBox(width: 15.w),

          ],
        ),
      ],
    );
  }
}