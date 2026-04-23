import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';


class VerificationCodeField extends StatelessWidget {
  final int length;
  final Function(String)? onCompleted;

  const VerificationCodeField({super.key, this.length = 4, this.onCompleted});

  @override
  Widget build(BuildContext context) {
    List<String> code = List.filled(length, "");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(length, (index) => SizedBox(
        width: 55.w,
        height: 65.h,
        child: TextFormField(
          onChanged: (value) {
            code[index] = value;
            if (value.length == 1) {
              if (index < length - 1) {
                FocusScope.of(context).nextFocus();
              } else {
                FocusScope.of(context).unfocus();
                if (onCompleted != null) onCompleted!(code.join());
              }
            }
          },
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          cursorColor: AppColor.primary,
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor:AppColor.primaryGrey,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColor.darkgreen, width: 2),
            ),
          ),
        ),
      )),
    );
  }
}