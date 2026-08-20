import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../data/models/my_subscription_model.dart';

class SubscriptionItemCard extends StatelessWidget {
  final MySubscriptionModel sub;
  final bool isHighlighted;

  const SubscriptionItemCard({
    super.key,
    required this.sub,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColor.primary.withOpacity(0.05)
            : AppColor.cardColor,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: isHighlighted ? AppColor.primary : AppColor.lightGrey,
          width: isHighlighted ? 2.0 : 1.0,
        ),
        boxShadow: isHighlighted
            ? [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.25),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ]
            : [],
      ),
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