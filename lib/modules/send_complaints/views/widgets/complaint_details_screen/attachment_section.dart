import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_color.dart';

class AttachmentsSection extends StatelessWidget {
  final List<String> urls;
  const AttachmentsSection({super.key, required this.urls});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("attachments".tr, style: TextStyle(color:AppColor.black,fontSize: 14.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.h),

        urls.isEmpty
            ? Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Text("no_attachments".tr, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
        )
            : SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: urls.length,
            itemBuilder: (_, i) => Container(
              margin: EdgeInsets.only(right: 10.w),
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: AppColor.grey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Image.network(
                urls[i],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColor.darkgreen,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),
          ),
        ),
      ],
    );
  }
}