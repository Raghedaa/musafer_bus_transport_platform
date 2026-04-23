import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../../data/models/booking_summary_model.dart';

class BookingSummaryController extends GetxController {

  var bookingSummaryModel = Rxn<BookingSummaryModel>();
  var paymentMethod = 'digital'.obs;
  final String pnrNumber = "BUS-8829-XP";


  void copyPNR() {
    Clipboard.setData(ClipboardData(text: pnrNumber));
    Get.snackbar("Copied", "PNR number has been copied successfully");  }

  void changePaymentMethod(String method) {
    paymentMethod.value = method;
  }
}