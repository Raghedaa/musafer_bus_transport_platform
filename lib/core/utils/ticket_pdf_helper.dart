import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:musafer/core/constants/app_color.dart';

class TicketPdfHelper {
  static Future<File> generateTicket({
    required String pnr,
    required String passengerName,
    required String seat,
    required String fromCity,
    required String toCity,
    required String departureTime,
    required String departureDate,
  }) async {
    final pdf = pw.Document();

    // تحويل لون التطبيق للـ PDF
    final pdfDarkGreen = PdfColor.fromInt(AppColor.darkgreen.value);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                // 1. Header - عنوان التذكرة
                pw.Text("Musafer - Bus Transport",
                    style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold, color: pdfDarkGreen)),
                pw.SizedBox(height: 10),
                pw.Divider(thickness: 1.5, color: PdfColors.grey300),
                pw.SizedBox(height: 15),

                // 2. Route Section - من وإلى
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoColumn("From", fromCity, pw.CrossAxisAlignment.start),
                    pw.Text("----->", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: pdfDarkGreen)),
                    _buildInfoColumn("To", toCity, pw.CrossAxisAlignment.end),
                  ],
                ),

                pw.SizedBox(height: 25),

                // 3. Passenger Details Card - تفاصيل الراكب
                pw.Container(
                  padding: const pw.EdgeInsets.all(15),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(10),
                    border: pw.Border.all(color: PdfColors.grey300),
                  ),
                  child: pw.Column(
                    children: [
                      _buildDataRow("Passenger Name:", passengerName),
                      pw.SizedBox(height: 8),
                      _buildDataRow("Seat Number:", seat),
                      pw.SizedBox(height: 8),
                      _buildDataRow("PNR Number:", pnr),
                      pw.SizedBox(height: 8),
                      _buildDataRow("Departure Time:", departureTime),
                      pw.SizedBox(height: 8),
                      _buildDataRow("Departure Date:", departureDate),
                    ],
                  ),
                ),

                pw.SizedBox(height: 40),

                // 4. QR Code Section
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: "PNR:$pnr | Name:$passengerName | From:$fromCity To:$toCity | Date:$departureDate",                  width: 140,
                  height: 140,
                ),
                pw.SizedBox(height: 10),
                pw.Text("Ticket ID: $pnr", style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
              ],
            ),
          );
        },
      ),
    );

    // منطق الحفظ
    final output = await getTemporaryDirectory(); // استخدام الـ Temp لتجنب مشاكل الصلاحيات أحياناً
    final file = File("${output.path}/Musafer_Ticket_$pnr.pdf");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // دالة مساعدة لبناء أعمدة الرحلة (From/To)
  static pw.Widget _buildInfoColumn(String label, String value, pw.CrossAxisAlignment alignment) {
    return pw.Column(
      crossAxisAlignment: alignment,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey)),
        pw.Text(value, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
      ],
    );
  }

  // دالة مساعدة لبناء أسطر البيانات (Label: Value)
  static pw.Widget _buildDataRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Text(value),
      ],
    );
  }
}