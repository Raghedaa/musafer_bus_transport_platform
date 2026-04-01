// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:musafer/core/constants/app_color.dart';
// import 'package:qr_flutter/qr_flutter.dart';
//
// class QrSection extends StatelessWidget {
//   final String data;
//   const QrSection({super.key, required this.data});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(20.w),
//       decoration: BoxDecoration(
//
//         color: AppColor.white,
//         borderRadius: BorderRadius.circular(20.r),
//         boxShadow: [BoxShadow(color: AppColor.black, blurRadius: 10.r)],
//       ),
//       child: Column(
//         children: [
//           QrImageView(
//             data: data,
//             version: QrVersions.auto,
//             size: 150.w,
//           ),
//           SizedBox(height: 10.h),
//           Text("Scan this QR code during boarding",
//               style: TextStyle(color: AppColor.grey, fontSize: 12.sp)),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrSection extends StatelessWidget {
  final String data;
  const QrSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        children: [
          QrImageView(
            data: data,
            version: QrVersions.auto,
            size: 160.w,
            gapless: false,
            // ألوان مخصصة إذا أردت
            eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black),
          ),
          SizedBox(height: 12.h),
          Text(
            "Scan this QR code during boarding",
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}