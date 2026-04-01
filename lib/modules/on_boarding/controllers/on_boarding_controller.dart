import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musafer/routes/app_routes/app_routes.dart';
import '../../../data/providers/static/onBoardingList.dart';

class OnBoardingControllerImp extends GetxController {
  PageController pageController = PageController();
  int currentPage = 0;

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }
  void onPageChanged(int index) {
    currentPage = index;
    update();
  }

  void next() {
    if (currentPage < onBoardingList.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      skip();
    }
  }

  void skip() {
    Get.offAllNamed(AppRoute.login);
  }

  void back() {
    if (currentPage > 0) {
      currentPage--;
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}

