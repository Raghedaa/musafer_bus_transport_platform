import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musafer/core/constants/app_color.dart';

class AuthToggle extends StatelessWidget {
  const AuthToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4.r)],
              ),
              child: const Center(child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold))),
            ),
          ),
          Expanded(
            child: Center(child: Text("Sign Up", style: TextStyle(color: AppColor.grey))),
          ),
        ],
      ),
    );
  }
}