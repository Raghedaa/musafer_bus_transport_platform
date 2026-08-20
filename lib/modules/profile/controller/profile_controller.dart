import 'package:get/get.dart';
import '../../../core/shared/custom_snackbar.dart';
import '../../../data/providers/stripe_provider.dart';
import '../../../data/repositories/profile_repository.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repo = ProfileRepository();
  var userData = {}.obs;
  var isLoading = true.obs;
  var isTopUpLoading = false.obs;

  String get userName => userData['name'] ?? "No Name";
  String get userPhone => userData['phone_number'] ?? "No Phone";

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    var data = await _repo.getProfile();
    if (data != null) userData.value = data;
    isLoading.value = false;
  }


  Future<void> topUpWallet(String currency, String amount) async {
    isTopUpLoading.value = true;

    try {
      if (currency == 'USD') {
        final stripeProvider = StripeProvider(); // أو يمكن استخدام Get.put لو مسجل كـ Controller
        final success = await stripeProvider.topUpWalletWithStripe(
          amount: double.parse(amount),
          currency: currency,
          onSuccess: (data) async {

          },
        );

        if (!success) {
          CustomSnackBar.showError("payment_failed");
          isTopUpLoading.value = false;
          return;
        }
      }

    final updatedWalletData = await _repo.topUpWallet(currency, amount);

      if (updatedWalletData != null) {
        var currentWallets = List.from(userData['wallets'] ?? []);

        int index = currentWallets.indexWhere((w) => w['id'] == updatedWalletData['id']);
        if (index != -1) {
          currentWallets[index] = updatedWalletData;
        } else {
          currentWallets.add(updatedWalletData);
        }

        userData['wallets'] = currentWallets;
        userData.refresh();

        Get.back();

        CustomSnackBar.showSuccess("wallet_topped_up_success");
      } else {
        CustomSnackBar.showError("wallet_top_up_failed");
      }
    } catch (e) {
      CustomSnackBar.showError("something_went_wrong");
    } finally {
      isTopUpLoading.value = false;
    }
  }

}