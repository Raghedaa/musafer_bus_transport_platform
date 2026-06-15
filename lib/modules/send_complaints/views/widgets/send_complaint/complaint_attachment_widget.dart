import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_color.dart';
import '../../../controllers/complaints_controller.dart';



class ComplaintAttachmentWidget extends GetView<ComplaintsController> {
  const ComplaintAttachmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Optional Attachment'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_photo_alternate),
              onPressed: () => controller.pickFiles(),
            ),
          ],
        ),
        Obx(() => Wrap(
          spacing: 8,
          children: controller.selectedFiles.map((file) => Chip(
            label: Text(file.name, style: TextStyle(fontSize: 10.sp)),
            onDeleted: () => controller.selectedFiles.remove(file),
          )).toList(),
        )),
      ],
    );
  }
}