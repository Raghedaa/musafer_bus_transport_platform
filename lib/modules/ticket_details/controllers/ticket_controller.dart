// import 'package:get/get.dart';
// import 'package:musafer/core/utils/ticket_pdf_helper.dart'; // استيراد المساعد
// import 'package:open_filex/open_filex.dart';
//
// class TicketController extends GetxController {
//   // هذه البيانات عادة تأتي من Model أو من Arguments
//   final String pnr = "PNR-7724X9";
//   final String passengerName = "A. Mansour";
//   final String seat = "14A (Window)";
//   final String fromCity = "Damascus";
//   final String toCity = "Aleppo";
//   final String departureTime = "10:30 AM";
//
//   Future<void> downloadTicket() async {
//     try {
//       // استدعاء الوظيفة من الـ Helper
//       final file = await TicketPdfHelper.generateTicket(
//         pnr: pnr,
//         passengerName: passengerName,
//         seat: seat,
//         fromCity: fromCity,
//         toCity: toCity,
//         departureTime: departureTime,
//       );
//
//       Get.snackbar("Success", "Ticket saved: ${file.path}");
//       await OpenFilex.open(file.path);
//     } catch (e) {
//       Get.snackbar("Error", "Could not generate PDF: $e");
//     }
//   }
//
//
//   void goToChangeSeat() {
//     // Get.toNamed(AppRoute.selectSeat);
//   }
//
//   void cancelBooking() {
//     // Get.offAllNamed(AppRoute.searchTrip);
//   }
// }
//
//



import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';

import '../../../core/utils/ticket_pdf_helper.dart';
import '../../../data/models/qr_ticket_model.dart';
// import 'package:musafer/core/utils/ticket_pdf_helper.dart'; // تأكد من المسار لديك

class TicketController extends GetxController {
  // تعريف الموديل كمتغير ملاحظ (Observable) أو عادي
  late QrTicketModel ticket;

  @override
  void onInit() {
    super.onInit();
    loadTicketData();
  }

  void loadTicketData() {
    // محاكاة وصول بيانات (غداً استبدلها بـ API Call)
    ticket = QrTicketModel(
        id: "#TR-94285",
        name: "mays Al-Zoubi",
        seatNumber: "12A",
        isPaid: true,
        route: "Damascus → Aleppo",
        date: "2026-04-10",
        status: "Upcoming"
    );
    update(); // لتحديث الواجهة
  }

  Future<void> downloadTicket() async {
    try {
      // استخدام بيانات الموديل لإنشاء الـ PDF

      final file = await TicketPdfHelper.generateTicket(
        pnr: ticket.id,
        passengerName: ticket.name,
        seat: ticket.seatNumber,
        fromCity: ticket.route.split('→')[0].trim(),
        toCity: ticket.route.split('→')[1].trim(),
        departureTime: "10:30 AM",
      );
      await OpenFilex.open(file.path);

      Get.snackbar("Success", "Ticket ready for download");
    } catch (e) {
      Get.snackbar("Error", "Could not generate PDF: $e");
    }
  }

  void goToChangeSeat() => print("Change Seat");
  void cancelBooking() => Get.back();
}