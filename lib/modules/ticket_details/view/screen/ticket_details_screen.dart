// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:musafer/modules/ticket_details/view/widget/booking_management.dart';
// import '../../../../core/constants/app_color.dart';
// import '../../controllers/ticket_controller.dart';
// import '../widget/ticket_header.dart';
// import '../widget/ticket_info_card.dart';
// import '../widget/qr_section.dart';
//
// class TicketDetailsScreen extends GetView<TicketController> {
//   const TicketDetailsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//     final controller = Get.put(TicketController());
//
//     return Scaffold(
//       backgroundColor: AppColor.white,
//       body: Column(
//         children: [
//           TicketHeader(),
//
//           Expanded(
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               child: Column(
//                 children: [
//                   const TicketInfoCard(),
//                   SizedBox(height: 20.h),
//                   QrSection(data: controller.pnr),
//                   SizedBox(height: 30.h),
//                   const BookingManagement(),
//                   SizedBox(height: 30.h),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/ticket_controller.dart';
import '../widget/qr_section.dart';
// استورد باقي الويدجتس الخاصة بك هنا

class TicketDetailsScreen extends StatelessWidget {
  const TicketDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام Get.put لإنشاء الكنترولر
    final controller = Get.put(TicketController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Ticket Details"), centerTitle: true),
      body: GetBuilder<TicketController>(
        builder: (_) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      // كرت المعلومات (تأكد أنه يقرأ من controller.ticket)
                      const Text("Ticket Info Card Placeholder"),

                      SizedBox(height: 20.h),

                      // تمرير البيانات المشفرة بصيغة JSON للـ QR
                      QrSection(data: controller.ticket.toQrString()),

                      SizedBox(height: 30.h),

                      ElevatedButton(
                        onPressed: () => controller.downloadTicket(),
                        child: const Text("Download PDF"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}