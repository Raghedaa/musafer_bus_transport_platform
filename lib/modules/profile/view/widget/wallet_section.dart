import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';

class WalletSection extends StatelessWidget {
  final List wallets;
  const WalletSection({super.key, required this.wallets});

  @override
  Widget build(BuildContext context) {
    final wallet = wallets.isNotEmpty ? wallets.first : null;
    if (wallet == null) return const SizedBox.shrink();

    final balances = wallet['balances'] as List;
    final usd = balances.firstWhere((b) => b['currency'] == 'USD', orElse: () => {'balance': '0', 'currency': 'USD'});
    final syp = balances.firstWhere((b) => b['currency'] == 'SYP', orElse: () => {'balance': '0', 'currency': 'SYP'});

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "Your Wallet".tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
        ),
        SizedBox(height: 15.h),

        Row(
          children: [
            _buildStatCard("USD".tr, usd['balance']),
            SizedBox(width: 15.w),
            _buildStatCard("SYP".tr, syp['balance']),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12.sp, color: AppColor.black),
            ),
            SizedBox(height: 5.h),
            Text(
              value,
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColor.black),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}