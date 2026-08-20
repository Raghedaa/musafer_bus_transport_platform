import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/modules/complaints/views/screen/complaint_details_screen.dart';
import '../../../../core/constants/app_color.dart';
import '../../controllers/my_complaints_controller.dart';
import '../widgets/my_complaints/complaint_card.dart';

class MyComplaintsScreen extends GetView<MyComplaintsController> {
  const MyComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {


    Get.put(MyComplaintsController());

    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey('refresh')) {
    }

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('my_complaints'.tr, style: TextStyle(color: AppColor.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AppColor.darkgreen));
        }
        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "لا يمكن تحميل الشكاوى، يرجى التحقق من اتصال الإنترنت".tr,
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => controller.fetchComplaints(),
                  child: Text("إعادة المحاولة".tr),
                ),
              ],
            ),
          );
        }

        if (controller.complaints.isEmpty) {
          return Center(child: Text("لا توجد شكاوى حالياً".tr));
        }
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: AppColor.darkgreen,
                onRefresh: controller.fetchComplaints,
                child: ListView.builder(
                  padding: EdgeInsets.all(20.w),
                  itemCount: controller.complaints.length,
                  itemBuilder: (_, i) {
                    final complaint = controller.complaints[i];
                    return Obx(() {
                      final isHighlighted = controller.highlightedComplaintId.value == complaint.id;
                      return ComplaintCard(
                        complaint: complaint,
                        isHighlighted: isHighlighted,
                        onTap: () => Get.to(() => ComplaintDetailsScreen(complaintId: complaint.id)),
                      );
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20.h,)
          ],
        );
      }),
    );
  }
}