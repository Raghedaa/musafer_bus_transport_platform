import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../booking_summary/controllers/booking_summary_controller.dart';
import '../../booking_summary/view/screen/booking_summary_screen.dart';
import '../../search_trip/view/screen/search_screen.dart';
import '../../select_seat/controllers/select_seat_controller.dart';
import '../../select_seat/view/screen/select_seat_screen.dart';
import '../../ticket_details/controllers/ticket_controller.dart';
import '../../ticket_details/view/screen/ticket_details_screen.dart';


class MainLayoutController extends GetxController {
  final RxInt currentIndex = 0.obs;

  RxList<Widget> exploreStack = <Widget>[const TripSearchScreen()].obs;



  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      currentIndex.value = Get.arguments;
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  void pushToExplore(Widget page) {
    exploreStack.add(page);
    exploreStack.refresh();
  }

  bool popExplore() {
    if (exploreStack.length > 1) {
      Widget topPage = exploreStack.last;

      if (topPage is TicketDetailsScreen) {
        Get.delete<TicketController>();
      } else if (topPage is BookingSummaryScreen) {
        Get.delete<BookingSummaryController>();
      } else if (topPage is SelectSeatScreen) {
        Get.delete<SelectSeatController>();
      }

      exploreStack.removeLast();
      update();
      return true;
    }
    return false;
  }

  Future<bool> onWillPop() async {
    if (currentIndex.value == 0) {
      bool canPopInternal = popExplore();
      return !canPopInternal;
    }
    return true;
  }
}