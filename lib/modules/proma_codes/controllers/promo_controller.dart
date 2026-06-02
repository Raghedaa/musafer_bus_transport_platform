import 'package:get/get.dart';
import '../../../data/repositories/promo_repository.dart';

class PromoController extends GetxController {
  final PromoRepository _repo = PromoRepository();
  var promoList = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPromos();
  }

  void fetchPromos() async {
    isLoading.value = true;
    promoList.value = await _repo.getPromoCodes();
    isLoading.value = false;
  }
}