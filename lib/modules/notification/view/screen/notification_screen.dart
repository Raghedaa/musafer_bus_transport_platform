import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../controller/notification_controller.dart';
import '../widget/notification_item.dart';

class NotificationScreen extends GetView<NotificationController> {
  // const NotificationScreen({super.key});

  final ScrollController _scrollController = ScrollController();

  NotificationScreen({super.key}) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        if (!controller.isMoreLoading.value && controller.currentPage < controller.lastPage) {
          controller.fetchNotifications(isLoadMore: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("notifications".tr), // ترجمة العنوان
            SizedBox(width: 10.w),
            // عداد الإشعارات غير المقروءة الكلي
            Obx(() => controller.unreadCount.value > 0
                ? Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                "${controller.unreadCount.value}",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
                : const SizedBox()),
          ],
        ),
        actions: [
          // زر تحديد الكل كمقروء (الصح)
          IconButton(
            icon:  Icon(Icons.done_all, color: AppColor.black),
            onPressed: () => controller.markAllAsRead(),
            tooltip: "mark_all_read".tr,
          ),
        ],
      ),

      body: Obx(() {
      if (controller.isLoading.value && controller.notifications.isEmpty) {
        return const Center(child: CircularProgressIndicator(color: AppColor.darkgreen,));
      }


      if (controller.notifications.isEmpty) {
        return RefreshIndicator(
          color: AppColor.darkgreen,
          onRefresh: () => controller.fetchNotifications(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(), // تجعل الـ ListView قابلاً للسحب حتى لو كان فارغاً
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.4), // دفع المحتوى للمنتصف
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 80.sp, color: Colors.grey),
                    SizedBox(height: 16.h),
                    Text(
                      "no_notifications".tr,
                      style: TextStyle(fontSize: 18.sp, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }


      return RefreshIndicator(
          color: AppColor.darkgreen,
        onRefresh: () => controller.fetchNotifications(),
        child: ListView.builder(
          controller: _scrollController, // ربط الـ Controller
          itemCount: controller.notifications.length + 1, // +1 من أجل مؤشر التحميل
          itemBuilder: (context, index) {
            if (index < controller.notifications.length) {
              return NotificationItem(notification: controller.notifications[index]);
            } else {
              // عرض مؤشر تحميل صغير في الأسفل أثناء جلب الصفحة الجديدة
              return Obx(() => controller.isMoreLoading.value
                  ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator(color: AppColor.darkgreen,)),
              )
                  : const SizedBox());
            }
          },
        ),
      );
    }),
    );
   }
}