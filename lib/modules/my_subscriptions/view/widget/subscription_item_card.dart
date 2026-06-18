import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../data/models/my_subscription_model.dart';


class SubscriptionItemCard extends StatelessWidget {
  final MySubscriptionModel sub;
  const SubscriptionItemCard({super.key, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: AppColor.cardColor, borderRadius: BorderRadius.circular(15.r), border: Border.all(color: AppColor.lightGrey)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.card_membership, color: AppColor.primary, size: 40.sp),
              SizedBox(width: 15.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sub.plan.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                    Text("${"Company".tr}: ${sub.plan.companyName}", style: TextStyle(fontSize: 12.sp, color: AppColor.greyText)),
                  ],
                ),
              ),
              // الحالة
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(color: AppColor.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20.r)),
                child: Text(sub.status.toUpperCase(), style: TextStyle(color: AppColor.green, fontSize: 12.sp, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${"Remaining Trips".tr}: ${sub.remainingTrips}", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                "${"Price".tr}: ${sub.plan.price} ${"SP".tr}",
                style: TextStyle(color: AppColor.primary),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Text("${"Expires at".tr}: ${sub.expiresAt.substring(0, 10)}", style: TextStyle(fontSize: 12.sp, color: AppColor.greyText)),
        ],
      ),
    );
  }
}