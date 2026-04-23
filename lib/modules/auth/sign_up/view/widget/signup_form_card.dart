import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/shared/custom_text_form_field.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/shared/custom_button.dart';
import '../../controllers/signup_controller.dart';

class SignUpFormCard extends StatelessWidget {
  const SignUpFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController signUpController = Get.put(SignUpController());

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PHONE NUMBER".tr, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColor.grey)),
          SizedBox(height: 10.h),
          CustomTextFormField(
            controller: signUpController.phoneController,
            keyboardType: TextInputType.phone,

              hint: "+963 9** *** ****",
              prefixIcon: (Icons.phone_android),

          ),
          SizedBox(height: 25.h),
          CustomButton(
            text: "Send Verification Code".tr,
            onPressed: () => signUpController.sendCode(),
          ),
        ],
      ),
    );
  }
}