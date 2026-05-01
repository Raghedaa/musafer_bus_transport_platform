import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/shared/management_tile.dart';
import '../../../../routes/app_routes/app_routes.dart';
import '../../../main_layout/controller/main_layout_controller.dart';
import 'package:get_storage/get_storage.dart';


class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Account Settings".tr,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold,color: AppColor.black),
        ),
        SizedBox(height: 15.h),

        ManagementTile(
          title: "Booking History".tr,
          subtitle: "View your past and upcoming trips".tr,
          icon: Icons.confirmation_number_outlined,
          iconColor: AppColor.primary,
          iconBgColor: AppColor.darkgreen.withOpacity(0.1),
          onTap: () {
            Get.offAllNamed('/main-layout', arguments: 0);
          },
        ),
        SizedBox(height: 12.h),

        ManagementTile(
          title: "Personal Information".tr,
          subtitle: "Edit your name, phone, and email".tr,
          icon: Icons.person_outline,
          iconColor: AppColor.blue,
          iconBgColor: Colors.blue.withOpacity(0.1),
          onTap: () {
            Get.toNamed(AppRoute.personal_info);
          },        ),
        SizedBox(height: 12.h),

        ManagementTile(
          title: "Notifications".tr,
          subtitle: "Manage your alerts and news".tr,
          icon: Icons.notifications_none,
          iconColor: AppColor.orange,
          iconBgColor: Colors.orange.withOpacity(0.1),
          onTap: () {},
        ),
        SizedBox(height: 12.h),

        ManagementTile(
          title: "Logout".tr,
          subtitle: "Sign out of your account".tr,
          icon: Icons.logout,
          iconColor: AppColor.red,
          iconBgColor: Colors.red.withOpacity(0.1),
          textColor: AppColor.red,
          trailing: const SizedBox.shrink(),
          onTap: () {
            final box = GetStorage();
            box.remove('token');
            box.remove('user_info');
            Get.offAllNamed(AppRoute.login);
            },
        ),
      ],
    );
  }
}
