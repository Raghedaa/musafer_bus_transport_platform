import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';

class VerificationCodeField extends StatelessWidget {
  final int length;
  final Function(String)? onCompleted;
  final Function(String)? onChanged;

  const VerificationCodeField({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    List<String> code = List.filled(length, "");

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          length,
          (index) => Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: SizedBox(
                height: 65.h,
                child: TextFormField(
                  onChanged: (value) {
                    code[index] = value;
                    if (onChanged != null) {
                      onChanged!(code.join().trim());
                    }

                    if (value.length == 1) {
                      if (index < length - 1) {
                        FocusScope.of(context).nextFocus();
                      } else {
                        FocusScope.of(context).unfocus();
                        if (onCompleted != null) onCompleted!(code.join());
                      }
                    } else if (value.isEmpty && index > 0) {
                      // ميزة إضافية: الرجوع للخلف عند المسح
                      FocusScope.of(context).previousFocus();
                    }
                  },
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  cursorColor: AppColor.primary,
                  enableInteractiveSelection: false,
                  decoration: InputDecoration(
                    counterText: "",
                    filled: true,
                    fillColor: AppColor.primaryGrey.withOpacity(0.5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColor.darkgreen,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
