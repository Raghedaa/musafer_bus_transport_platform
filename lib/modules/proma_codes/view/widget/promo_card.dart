import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/shared/custom_snackbar.dart';
import '../screen/promo_details_screen.dart';

class PromoCard extends StatelessWidget {
  final dynamic promo;
  const PromoCard({super.key, required this.promo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: InkWell(
          onTap: () {
            Get.to(() => PromoDetailsScreen(promo: promo));
          },
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(promo['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.primary)),
                Text(promo['description'], style: TextStyle(fontSize: 14, color: AppColor.greyText)),
              ],
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Valid until".tr + ": " + promo['valid_to'].toString().substring(0, 10)),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: promo['code']));
                    CustomSnackBar.showSuccess("Code copied to clipboard");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: AppColor.white,
                  ),
                  child: Text(promo['code']),
                )
              ],
            ),
          ),
        ],
      ),
      ));
  }
}