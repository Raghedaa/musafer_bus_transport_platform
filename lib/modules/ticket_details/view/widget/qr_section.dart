import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrSection extends StatelessWidget {
  final String pnr;

  const QrSection({super.key, required this.pnr});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            QrImageView(
              data: pnr,
              version: QrVersions.auto,
              size: 160.w,
              gapless: false,
              eyeStyle: QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColor.black,
              ),
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: AppColor.black,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "Scan this QR code during boarding".tr,
              style: TextStyle(
                color: AppColor.black,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      );
  }
}
