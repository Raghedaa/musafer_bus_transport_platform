import 'package:get/get.dart';

class MainLayoutController extends GetxController {
  var currentIndex = 0.obs;

  // مفتاح فريد لنافيجيتور تبويب البحث
  final searchNavigatorKey = Get.nestedKey(1);

  void changePage(int index) {
    currentIndex.value = index;
  }

  // دالة للعودة للخلف داخل التبويب
  Future<bool> onWillPop() async {
    if (searchNavigatorKey?.currentState?.canPop() ?? false) {
      searchNavigatorKey?.currentState?.pop();
      return false;
    }
    return true;
  }
}