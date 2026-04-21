import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/shared/management_tile.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Account Settings",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15.h),

        // 1. الحجوزات (Booking History)
        ManagementTile(
          title: "Booking History",
          subtitle: "View your past and upcoming trips",
          icon: Icons.confirmation_number_outlined,
          iconColor: AppColor.darkgreen,
          iconBgColor: AppColor.darkgreen.withOpacity(0.1),
          onTap: () => Get.toNamed('/booking-history'),
        ),
        SizedBox(height: 12.h),

        // 2. المعلومات الشخصية
        ManagementTile(
          title: "Personal Information",
          subtitle: "Edit your name, phone, and email",
          icon: Icons.person_outline,
          iconColor: Colors.blue,
          iconBgColor: Colors.blue.withOpacity(0.1),
          onTap: () {},
        ),
        SizedBox(height: 12.h),

        // 3. التنبيهات
        ManagementTile(
          title: "Notifications",
          subtitle: "Manage your alerts and news",
          icon: Icons.notifications_none,
          iconColor: Colors.orange,
          iconBgColor: Colors.orange.withOpacity(0.1),
          onTap: () {},
        ),
        SizedBox(height: 12.h),

        // 4. تسجيل الخروج
        ManagementTile(
          title: "Logout",
          subtitle: "Sign out of your account",
          icon: Icons.logout,
          iconColor: Colors.red,
          iconBgColor: Colors.red.withOpacity(0.1),
          textColor: Colors.red,
          trailing: const SizedBox.shrink(), // لإخفاء السهم في زر الخروج
          onTap: () {
            // منطق تسجيل الخروج
          },
        ),
      ],
    );
  }
}