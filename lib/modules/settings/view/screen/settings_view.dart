// lib/modules/settings/views/screen/settings_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../routes/app_routes/app_routes.dart';
import '../../../main_layout/controller/main_layout_controller.dart';
import '../../../complaints/views/screen/my_complaints_screen.dart';
import '../../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());
    final themeController = Get.find<ThemeController>();

    return Obx(() => Scaffold(

      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        elevation: 0,

        title: Text(
            "settings".tr,
            style: TextStyle(
                color: AppColor.black,
                fontWeight: FontWeight.bold
            )
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColor.black),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),

            _buildSettingTile(
              icon: Icons.language,
              title: "language".tr,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => controller.changeLanguage('ar'),
                    child: Text("العربية".tr, style: TextStyle(color: AppColor.black)),
                  ),
                  Text("|", style: TextStyle(color: AppColor.black)),
                  TextButton(
                    onPressed: () => controller.changeLanguage('en'),
                    child: Text("English".tr, style: TextStyle(color: AppColor.black)),
                  ),
                ],
              ),
            ),

            Divider(color: AppColor.grey.withOpacity(0.2)),

            _buildSettingTile(
              icon: Icons.dark_mode,
              title: "DarkMode".tr,
              trailing: Switch(
                value: themeController.isDarkMode.value,
                onChanged: (val) {
                  themeController.toggleTheme();
                },
                activeColor: AppColor.primary,
              ),
            ),

            Divider(color: AppColor.grey.withOpacity(0.2)),

            _buildSettingTile(
              icon: Icons.comment,
              title: "my_complaints".tr,
              trailing: Icon(Icons.arrow_forward_ios, size: 16.sp, color: AppColor.black),
              onTap: () => Get.toNamed(AppRoute.myComplaints),            ),
            Divider(color: AppColor.grey.withOpacity(0.2)),
          ],
        ),
      ),
    ));
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    VoidCallback? onTap
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColor.primary),
      title: Text(
          title,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.black
          )
      ),
      trailing: trailing,
    );
  }}