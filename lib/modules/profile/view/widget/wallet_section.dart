import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musafer/core/shared/custom_snackbar.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/shared/custom_text_form_field.dart';
import '../../controller/profile_controller.dart';

class WalletSection extends StatelessWidget {
  final List wallets;
  const WalletSection({super.key, required this.wallets});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    final wallet = wallets.isNotEmpty ? wallets.first : null;
    if (wallet == null) return const SizedBox.shrink();

    final balances = wallet['balances'] as List;
    final usd = balances.firstWhere((b) => b['currency'] == 'USD', orElse: () => {'balance': '0', 'currency': 'USD'});
    final syp = balances.firstWhere((b) => b['currency'] == 'SYP', orElse: () => {'balance': '0', 'currency': 'SYP'});

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Your Wallet".tr,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.black,
              ),
            ),
            InkWell(
              onTap: () => _showTopUpDialog(context, controller),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: AppColor.darkgreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: AppColor.black.withOpacity(0.7), size: 18.sp),
                    SizedBox(width: 5.w),
                    Text(
                      "top_up".tr,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

  void _showTopUpDialog(BuildContext context, ProfileController controller) {
    final Rxn<String> selectedCurrency = Rxn<String>();
    final TextEditingController amountController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        title: Text("top_up_wallet".tr, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        content: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField<String>(
              hint: "select_currency".tr,
              initialDropdownHint: "select_currency".tr,
              dropdownItems: const [
                DropdownMenuItem(value: 'USD', child: Text('USD')),
                DropdownMenuItem(value: 'SYP', child: Text('SYP')),
              ],
              dropdownValue: selectedCurrency.value,
              onDropdownChanged: (val) {
                selectedCurrency.value = val;
              },
            ),
            SizedBox(height: 15.h),
            CustomTextFormField(
              hint: "enter_amount".tr,
              controller: amountController,
              keyboardType: TextInputType.number,
            ),
          ],
        )),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("cancel".tr, style: TextStyle(color: Colors.grey)),
          ),
          Obx(() => controller.isTopUpLoading.value
              ?  CircularProgressIndicator(color: AppColor.darkgreen,)
              : ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.darkgreen),
            onPressed: () {
              if (selectedCurrency.value != null && amountController.text.isNotEmpty) {
                controller.topUpWallet(selectedCurrency.value!, amountController.text);
                Get.back();
              } else {

                CustomSnackBar.show(
                 title: "attention".tr,
                  message:"please_select_currency_and_amount".tr,
                    isError: true,
                );
              }
            },
            child: Text("top_up".tr, style: TextStyle(color: Colors.white)),
          )),
        ],
      ),
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