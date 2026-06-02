import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';

class PromoDetailsScreen extends StatelessWidget {
  final dynamic promo;

  const PromoDetailsScreen({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: AppBar(
        title: Text("Promo Details".tr, style: TextStyle(color: AppColor.white)),
        backgroundColor: AppColor.primary,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: AppColor.primary.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  Icon(Icons.local_offer, size: 60.sp, color: AppColor.amber),
                  SizedBox(height: 15.h),
                  Text(promo['name'],
                    style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Details List
            _buildDetailItem(Icons.description, "Description".tr, promo['description'], AppColor.blue),
            _buildDetailItem(Icons.confirmation_number, "Code".tr, promo['code'], AppColor.orange),
            _buildDetailItem(Icons.pie_chart, "Type".tr, promo['type'].toString().capitalizeFirst ?? "", AppColor.teal),
            _buildDetailItem(Icons.percent, "Discount Value".tr, "${promo['value']}%", AppColor.green),
            _buildDetailItem(Icons.monetization_on, "Max Discount".tr, promo['max_discount_amount'].toString(), AppColor.amber),
            _buildDetailItem(Icons.calendar_today, "Valid Until".tr, promo['valid_to'].toString().substring(0, 10), AppColor.red),
            _buildDetailItem(Icons.event_available, "Valid Days".tr, (promo['conditions']['valid_days'] as List).join(', '), AppColor.pink),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value, Color iconColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: AppColor.greyText, fontSize: 12.sp)),
                SizedBox(height: 4.h),
                Text(value, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColor.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}