import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/services/api_service.dart';
import '../../booking_history/controllers/booking_history_controller.dart';
import '../../booking_history/view/screen/booking_history_screen.dart';
import '../../booking_summary/controllers/booking_summary_controller.dart';
import '../../booking_summary/view/screen/booking_summary_screen.dart';
import '../../profile/controller/profile_controller.dart';
import '../../profile/view/screen/profile_view.dart';
import '../../search_trip/controllers/search_controller.dart';
import '../../search_trip/view/screen/search_screen.dart';
import '../../select_seat/controllers/select_seat_controller.dart';
import '../../select_seat/view/screen/select_seat_screen.dart';
import '../../settings/view/screen/settings_view.dart';
import '../../subscription/controllers/subscription_controller.dart';
import '../../subscription_details/controllers/subscription_details_controller.dart';
import '../../ticket_details/controllers/ticket_controller.dart';
import '../../ticket_details/view/screen/ticket_details_screen.dart';


class MainLayoutController extends GetxController {
  final RxInt currentIndex = 2.obs;

  RxList<Widget> exploreStack = <Widget>[const TripSearchScreen()].obs;
  final ApiService _apiService = Get.find<ApiService>();


  RxList<Widget> bookingStack = <Widget>[const BookingHistoryScreen()].obs;
  RxList<Widget> subscriptionStack = <Widget>[].obs;
  RxList<Widget> notificationStack = <Widget>[const SettingsView()].obs;
  RxList<Widget> profileStack = <Widget>[const ProfileView()].obs;

  @override
  void onInit() {
    super.onInit();
    _verifyUserStatusWithServer();

    if (Get.arguments != null) {
      currentIndex.value = Get.arguments;
    }

    ever(currentIndex, (index) {
      if (index == 0 && Get.isRegistered<BookingHistoryController>()) {
        Get.find<BookingHistoryController>().fetchBookings();
      }
      if (index == 1 && Get.isRegistered<SubscriptionController>()) {
        Get.find<SubscriptionController>().loadPlans();
      }
      if (index == 2 && Get.isRegistered<TripSearchController>()) {
        Get.find<TripSearchController>().fetchCities();
        Get.find<TripSearchController>().fetchPopularTrips();
      }
      if (index == 4 && Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().fetchData();
      }
    });
  }



  void resetStack(int index) {
    switch (index) {
      case 0:
        if (Get.isRegistered<TicketController>()) {
          Get.delete<TicketController>();
        }
        bookingStack.assignAll([const BookingHistoryScreen()]);
        break;
      case 1:
        subscriptionStack.clear();
        break;
      case 4:
        profileStack.assignAll([const ProfileView()]);
        break;
    }
    update();
    bookingStack.refresh();
  }


  void pushToProfileStack(Widget page) {
    profileStack.add(page);
    update();
  }

  bool popProfileStack() {
    if (profileStack.length > 1) {
      profileStack.removeLast();
      update();
      return true;
    }
    return false;
  }
  void pushToNotificationStack(Widget page) {
    notificationStack.add(page);
    update();
  }

  bool popNotificationStack() {
    if (notificationStack.length > 1) {
      notificationStack.removeLast();
      update();
      return true;
    }
    return false;
  }

  void changePage(int index) {
    if (currentIndex.value == index) {
      resetStack(index);
      if (index == 2) {
        exploreStack.assignAll([const TripSearchScreen()]);
      }
    } else {
      if (index == 0) {
        resetStack(0);
      }
      currentIndex.value = index;
    }
  }


  void resetAndGoToBookings() {
    print('🟢 [resetAndGoToBookings] START');

    if (!Get.isRegistered<BookingHistoryController>()) {
      Get.put(BookingHistoryController());
    }

    final bookingCtrl = Get.find<BookingHistoryController>();

   bookingStack.assignAll([const BookingHistoryScreen()]);
    bookingStack.refresh();

    currentIndex.value = 0;
    update();

    print('🟢 [resetAndGoToBookings] END');
  }

  void pushToBookings(Widget page, {dynamic arguments}) {
    if (page is SelectSeatScreen) {
      if (bookingStack.isNotEmpty && bookingStack.last is! SelectSeatScreen) {
        bookingStack.add(page);
        update();
        bookingStack.refresh();
        return;
      }
    }

    bookingStack.add(page);
    update();
    bookingStack.refresh();
  }

  void pushToSubscription(Widget page) {
    if (!Get.isRegistered<SubscriptionDetailsController>()) {
      Get.put(SubscriptionDetailsController());
    }
    subscriptionStack.add(page);
    update();
  }
  bool popSubscription() {
    if (subscriptionStack.isNotEmpty) {
      subscriptionStack.removeLast();
      update();
      return true;
    }
    return false;
  }


  bool popBookings() {
    if (bookingStack.length > 1) {
      Widget topPage = bookingStack.last;

      bool isSelectSeat = topPage is SelectSeatScreen;

      if (Get.isRegistered<BookingHistoryController>()) {
        Get.find<BookingHistoryController>().clearHighlight();
      }

      bookingStack.removeLast();
      update();
      bookingStack.refresh();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (topPage is TicketDetailsScreen) {
        } else if (topPage is SelectSeatScreen) {
          if (Get.isRegistered<SelectSeatController>()) {
            Get.delete<SelectSeatController>(force: true);
          }
        }
      });

      return true;
    }
    return false;
  }
  void _verifyUserStatusWithServer() async {
    try {

      await _apiService.get(endPoint: 'passenger/bookings');

      print("User is verified and valid on the server.");
    } catch (e) {
      print("Error during silent login check: $e");
    }
  }

  void pushToExplore(Widget page) {
    exploreStack.add(page);
    update();
    exploreStack.refresh();
  }

  bool popExplore() {
    if (exploreStack.length > 1) {
      Widget topPage = exploreStack.last;

      exploreStack.removeLast();
      update();
      exploreStack.refresh();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (topPage is TicketDetailsScreen) {
          if (Get.isRegistered<TicketController>()) {
            Get.delete<TicketController>();
          }
        } else if (topPage is BookingSummaryScreen) {
          if (Get.isRegistered<BookingSummaryController>()) {
            Get.delete<BookingSummaryController>();
          }
        }
      });

      return true;
    }
    return false;
  }


  Future<bool> onWillPop() async {
    if (currentIndex.value == 0) {
      if (bookingStack.length > 1) {
        popBookings();
        return false;
      }
    } else if (currentIndex.value == 2) {
      if (exploreStack.length > 1) {
        popExplore();
        return false;
      }
    } else if (currentIndex.value == 4) {
      if (profileStack.length > 1) {
        popProfileStack();
        return false;
      }
    }

    if (currentIndex.value != 2) {
      changePage(2);
      return false;
    }

    return true;
  }
  void navigateBack() {
    if (currentIndex.value == 0) {
      popBookings();
    } else if (currentIndex.value == 2) {
      if (!popExplore()) {
        changePage(2);
      }
    } else if (currentIndex.value == 4) {
      popProfileStack();
    } else {
      changePage(2);
    }
  }
}