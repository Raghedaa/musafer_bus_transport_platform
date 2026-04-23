import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';

class ComplaintsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ComplaintsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "send Complaint".tr,
        style: TextStyle(color: AppColor.black, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: CircleAvatar(
          backgroundColor: AppColor.cardColor,
          child: IconButton(
            icon:  Icon(Icons.arrow_back_ios_new, size: 18, color: AppColor.black),
            onPressed: () => Get.back(),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}