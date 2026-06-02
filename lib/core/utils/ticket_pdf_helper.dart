import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:musafer/core/constants/app_color.dart';
import 'package:get/get.dart';
import '../../data/models/trip_model.dart';
import '../../modules/profile/controller/profile_controller.dart';
import '../localization/my_locale.dart';
import 'app_formatter.dart';
import 'package:get_storage/get_storage.dart';



class TicketPdfHelper {

  // --- دالة المعالجة اليدوية للأحرف العربية ---
  static String formatArabic(String text) {
    if (text.isEmpty) return text;
    // هذه دالة تعتمد على الاتجاه الصحيح للـ PDF
    // إذا ظهرت الأحرف متقطعة، تأكد أن الخط المستخدم (Tajawal) معرف بشكل صحيح
    return text;
  }

  static Future<File> generateTicket({
    required Map<String, dynamic> data,
    required TripModel trip,
  }) async {
    final pdf = pw.Document();

    final regularFont = await rootBundle.load('assets/fonts/Tajawal/Tajawal-Regular.ttf');
    final boldFont = await rootBundle.load('assets/fonts/Tajawal/Tajawal-Bold.ttf');
    final extraBoldFont = await rootBundle.load('assets/fonts/Tajawal/Tajawal-ExtraBold.ttf');

    final tajawalRegular = pw.Font.ttf(regularFont.buffer.asByteData());
    final tajawalBold = pw.Font.ttf(boldFont.buffer.asByteData());
    final tajawalExtraBold = pw.Font.ttf(extraBoldFont.buffer.asByteData());

    final isArabic = Get.locale?.languageCode == 'ar';
    final translations = MyTranslation().keys;
    final currentLang = isArabic ? 'ar' : 'en';
    final t = translations[currentLang]!;
    final pdfDarkGreen = PdfColor.fromInt(AppColor.darkgreen.value);


    final profileCtrl = Get.find<ProfileController>();

    final String passengerName = profileCtrl.userName.isNotEmpty
        ? profileCtrl.userName
        : "Guest";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(
              crossAxisAlignment: isArabic ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    isArabic ? (t['Your Ticket'] ?? "تذكرتك") : (t['Your Ticket'] ?? "Your Ticket"),
                    style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold, color: pdfDarkGreen, font: isArabic ? tajawalExtraBold : null),
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Container(height: 1.5, color: pdfDarkGreen),
                pw.SizedBox(height: 25),

                // داخل دالة generateTicket
                // استبدل الـ Row الخاص بالمسار بهذا الكود:
                pw.Directionality(
                  textDirection: isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn(isArabic ? (t['FROM'] ?? "من") : "From", trip.originCity, pdfDarkGreen, isArabic, tajawalRegular, tajawalBold),

                      // مسافة وفراغ
                      pw.SizedBox(width: 20),

                      // السهم (يقلب اتجاهه حسب اللغة)
                      pw.Text(isArabic ? "<-------" : "------->",
                          style: pw.TextStyle(color: pdfDarkGreen, fontSize: 16)),

                      pw.SizedBox(width: 20),

                      _buildInfoColumn(isArabic ? (t['TO'] ?? "إلى") : "To", trip.destinationCity, pdfDarkGreen, isArabic, tajawalRegular, tajawalBold),
                    ],
                  ),
                ),
                pw.SizedBox(height: 25),

                // تفاصيل الرحلة
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(color: PdfColors.grey100, borderRadius: pw.BorderRadius.circular(8)),
                  child: pw.Column(
                    crossAxisAlignment: isArabic ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
                    children: [
                      // بدلاً من trip.originStation
                      _buildDataRow(
                          isArabic ? "محطة المغادرة" : "Departure Station:",
                          trip.originStation?.name ?? "N/A", // هنا التعديل: الوصول للـ name
                          isArabic, tajawalRegular, tajawalBold
                      ),
                      _buildDataRow(
                          isArabic ? "محطة الوصول" : "Arrival Station:",
                          trip.destinationStation?.name ?? "N/A", // هنا التعديل: الوصول للـ name
                          isArabic, tajawalRegular, tajawalBold
                      ),
                      // سطر جديد للتاريخ
                      _buildDataRow(isArabic ? "التاريخ" : "Date:", trip.tripDate, isArabic, tajawalRegular, tajawalBold),

                      // سطر وقت المغادرة
                      // استدعاء مباشر كما هي تماماً، وستعمل لأننا قمنا بتبديل لغة Get مؤقتاً
                      _buildDataRow(
                          isArabic ? "وقت المغادرة" : "Departure Time:",
                          AppFormatter.formatTime(trip.departureTime),
                          isArabic, tajawalRegular, tajawalBold
                      ),

                      _buildDataRow(
                          isArabic ? "وقت الوصول" : "Arrival Time:",
                          trip.arrivalTime != null ? AppFormatter.formatTime(trip.arrivalTime!) : "--:--",
                          isArabic, tajawalRegular, tajawalBold
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 25),

                // _buildDataRow(isArabic ? "الراكب" : "Passenger:", data['passenger']['name'] ?? "Guest", isArabic, tajawalRegular, tajawalBold),

                _buildDataRow(
                    isArabic ? "الراكب" : "Passenger:",
                    passengerName,
                    isArabic,
                    tajawalRegular,
                    tajawalBold
                ),
                _buildDataRow(isArabic ? "المقاعد" : "Seats:", (data['seat_numbers'] as List).join(", "), isArabic, tajawalRegular, tajawalBold),
                _buildDataRow(isArabic ? "رمز الحجز (PNR)" : "PNR Code:", data['pnr_code'], isArabic, tajawalRegular, tajawalBold),

                pw.SizedBox(height: 50),
                pw.Center(
                  child: pw.BarcodeWidget(barcode: pw.Barcode.qrCode(), data: data['pnr_code'], width: 100, height: 100),
                ),
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/Ticket_${data['pnr_code']}.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildInfoColumn(String label, String value, PdfColor color, bool isArabic, pw.Font reg, pw.Font bold) {
    return pw.Column(
      crossAxisAlignment: isArabic ? pw.CrossAxisAlignment.end : pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: pw.TextStyle(fontSize: 10, font: isArabic ? reg : null)),
        pw.SizedBox(height: 4),
        pw.Text(value, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: color, font: isArabic ? bold : null)),
      ],
    );
  }

  static pw.Widget _buildDataRow(String label, String value, bool isArabic, pw.Font reg, pw.Font bold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      // هنا نستخدم Directionality بدلاً من الخاصية داخل الـ Row
      child: pw.Directionality(
        textDirection: isArabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: isArabic ? bold : null)),
            pw.Text(value, style: pw.TextStyle(font: isArabic ? reg : null)),
          ],
        ),
      ),
    );
  }
}