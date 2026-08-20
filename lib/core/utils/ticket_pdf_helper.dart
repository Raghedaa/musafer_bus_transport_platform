import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:musafer/core/constants/app_color.dart';
import 'package:musafer/data/models/trip_model.dart';
import 'package:musafer/modules/profile/controller/profile_controller.dart';

import '../localization/my_locale.dart';
import 'app_formatter.dart';


class TicketPdfHelper {
  /// معالجة النص العربي
  static String formatArabic(String text) {
    if (text.isEmpty) return text;
    return text;
  }

  static Future<File> generateTicket({
    required Map<String, dynamic> data,
    required TripModel trip,
  }) async {
    final pdf = pw.Document();

    // تحميل الخطوط
    final regularFont = await rootBundle.load(
      'assets/fonts/Tajawal/Tajawal-Regular.ttf',
    );

    final boldFont = await rootBundle.load(
      'assets/fonts/Tajawal/Tajawal-Bold.ttf',
    );

    final extraBoldFont = await rootBundle.load(
      'assets/fonts/Tajawal/Tajawal-ExtraBold.ttf',
    );

    final tajawalRegular = pw.Font.ttf(
      regularFont.buffer.asByteData(),
    );

    final tajawalBold = pw.Font.ttf(
      boldFont.buffer.asByteData(),
    );

    final tajawalExtraBold = pw.Font.ttf(
      extraBoldFont.buffer.asByteData(),
    );

    final isArabic = Get.locale?.languageCode == 'ar';

    final translations = MyTranslation().keys;
    final currentLang = isArabic ? 'ar' : 'en';
    final translationsMap = translations[currentLang] ?? {};

    final pdfDarkGreen = PdfColor.fromInt(
      AppColor.darkgreen.value,
    );

    final pdfSeats = (data['seat_numbers'] as List? ?? [])
        .map((seat) => seat.toString().trim())
        .where((seat) => seat.isNotEmpty)
        .join(', ');

    // رقم الحجز
    final pnrCode = data['pnr_code']?.toString() ?? '';

    // جلب بيانات المستخدم
    String passengerName = "Guest";

    if (Get.isRegistered<ProfileController>()) {
      final profileController = Get.find<ProfileController>();

      if (profileController.userName.trim().isNotEmpty) {
        passengerName = profileController.userName.trim();
      }
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        textDirection: isArabic
            ? pw.TextDirection.rtl
            : pw.TextDirection.ltr,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(30),
            child: pw.Column(
              crossAxisAlignment: isArabic
                  ? pw.CrossAxisAlignment.end
                  : pw.CrossAxisAlignment.start,
              children: [
                // عنوان التذكرة
                pw.Center(
                  child: pw.Text(
                    isArabic
                        ? (translationsMap['Your Ticket'] ?? 'تذكرتك')
                        : (translationsMap['Your Ticket'] ?? 'Your Ticket'),
                    style: pw.TextStyle(
                      fontSize: 26,
                      fontWeight: pw.FontWeight.bold,
                      color: pdfDarkGreen,
                      font: isArabic ? tajawalExtraBold : null,
                    ),
                  ),
                ),

                pw.SizedBox(height: 5),

                pw.Container(
                  height: 1.5,
                  color: pdfDarkGreen,
                ),

                pw.SizedBox(height: 25),

                // خط الرحلة
                pw.Directionality(
                  textDirection: isArabic
                      ? pw.TextDirection.rtl
                      : pw.TextDirection.ltr,
                  child: pw.Row(
                    mainAxisAlignment:
                    pw.MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn(
                        isArabic
                            ? (translationsMap['FROM'] ?? 'من')
                            : 'From',
                        trip.originCity,
                        pdfDarkGreen,
                        isArabic,
                        tajawalRegular,
                        tajawalBold,
                      ),

                      pw.SizedBox(width: 20),

                      pw.Text(
                        isArabic ? '<-------' : '------->',
                        style: pw.TextStyle(
                          color: pdfDarkGreen,
                          fontSize: 16,
                        ),
                      ),

                      pw.SizedBox(width: 20),

                      _buildInfoColumn(
                        isArabic
                            ? (translationsMap['TO'] ?? 'إلى')
                            : 'To',
                        trip.destinationCity,
                        pdfDarkGreen,
                        isArabic,
                        tajawalRegular,
                        tajawalBold,
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 25),

                // تفاصيل الرحلة
                pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: isArabic
                        ? pw.CrossAxisAlignment.end
                        : pw.CrossAxisAlignment.start,
                    children: [
                      _buildDataRow(
                        isArabic
                            ? 'محطة المغادرة'
                            : 'Departure Station:',
                        trip.originStation?.name ?? 'N/A',
                        isArabic,
                        tajawalRegular,
                        tajawalBold,
                      ),

                      _buildDataRow(
                        isArabic
                            ? 'محطة الوصول'
                            : 'Arrival Station:',
                        trip.destinationStation?.name ?? 'N/A',
                        isArabic,
                        tajawalRegular,
                        tajawalBold,
                      ),

                      _buildDataRow(
                        isArabic ? 'التاريخ' : 'Date:',
                        trip.tripDate.toString(),
                        isArabic,
                        tajawalRegular,
                        tajawalBold,
                      ),

                      _buildDataRow(
                        isArabic
                            ? 'وقت المغادرة'
                            : 'Departure Time:',
                        AppFormatter.formatTime(
                          trip.departureTime,
                        ),
                        isArabic,
                        tajawalRegular,
                        tajawalBold,
                      ),

                      _buildDataRow(
                        isArabic
                            ? 'وقت الوصول'
                            : 'Arrival Time:',
                        trip.arrivalTime != null
                            ? AppFormatter.formatTime(
                          trip.arrivalTime!,
                        )
                            : '--:--',
                        isArabic,
                        tajawalRegular,
                        tajawalBold,
                      ),
                    ],
                  ),
                ),

                pw.SizedBox(height: 25),

                // اسم الراكب
                _buildDataRow(
                  isArabic ? 'الراكب' : 'Passenger:',
                  passengerName,
                  isArabic,
                  tajawalRegular,
                  tajawalBold,
                ),

                _buildDataRow(
                  isArabic ? 'المقاعد' : 'Seats:',
                  pdfSeats.isEmpty ? '--' : pdfSeats,
                  isArabic,
                  tajawalRegular,
                  tajawalBold,
                ),


                // رقم الحجز
                _buildDataRow(
                  isArabic ? 'رمز الحجز (PNR)' : 'PNR Code:',
                  pnrCode,
                  isArabic,
                  tajawalRegular,
                  tajawalBold,
                ),

                pw.SizedBox(height: 50),

                // QR Code
                pw.Center(
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: pnrCode,
                    width: 100,
                    height: 100,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final outputDirectory = await getTemporaryDirectory();

    final file = File(
      '${outputDirectory.path}/Ticket_$pnrCode.pdf',
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    return file;
  }

  static pw.Widget _buildInfoColumn(
      String label,
      String value,
      PdfColor color,
      bool isArabic,
      pw.Font regularFont,
      pw.Font boldFont,
      ) {
    return pw.Column(
      crossAxisAlignment: isArabic
          ? pw.CrossAxisAlignment.end
          : pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 10,
            font: isArabic ? regularFont : null,
          ),
        ),

        pw.SizedBox(height: 4),

        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: color,
            font: isArabic ? boldFont : null,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildDataRow(
      String label,
      String value,
      bool isArabic,
      pw.Font regularFont,
      pw.Font boldFont,
      ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Directionality(
        textDirection: isArabic
            ? pw.TextDirection.rtl
            : pw.TextDirection.ltr,
        child: pw.Row(
          mainAxisAlignment:
          pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              child: pw.Text(
                label,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: isArabic ? boldFont : null,
                ),
              ),
            ),

            pw.SizedBox(width: 15),

            pw.Expanded(
              child: pw.Text(
                value,
                textAlign: isArabic
                    ? pw.TextAlign.left
                    : pw.TextAlign.right,
                style: pw.TextStyle(
                  font: isArabic ? regularFont : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}