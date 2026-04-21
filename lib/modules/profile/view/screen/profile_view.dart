import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../controller/profile_controller.dart';
import '../widget/profile_header.dart';
import '../widget/profile_menu_section.dart';
import '../widget/stats_section.dart';


class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            children: [
              const ProfileHeader(),
              SizedBox(height: 25.h),
              const StatsSection(),
              SizedBox(height: 30.h),
              const ProfileMenuSection(),
            ],
          ),
        ),
      ),
    );
  }
}