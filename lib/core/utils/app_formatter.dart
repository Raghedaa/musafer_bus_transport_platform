import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppFormatter {

  static String formatTime(String input) {
    try {
      // parse بدون toLocal() — نعرض الوقت كما أرسله السيرفر
      final dt = DateTime.parse(input);

      String formatted = DateFormat('h:mm a', 'en_US').format(dt);

      if (Get.locale?.languageCode == 'ar') {
        formatted = formatted
            .replaceAll("AM", "صباحاً")
            .replaceAll("PM", "مساءً");
      }

      return formatted;
    } catch (e) {
      return input;
    }
  }

  static String formatDuration(String hhmm) {
    try {
      final parts = hhmm.split(':');
      if (parts.length >= 2) {
        final h = parts[0].padLeft(2, '0');
        final m = parts[1].padLeft(2, '0');
        return "$h:$m";
      }
      return hhmm;
    } catch (e) {
      return hhmm;
    }
  }

  static String formatDate(String date) {
    try {
      final dt = DateTime.parse(date);

      final monthsAr = [
        "كانون الثاني", "شباط", "آذار", "نيسان", "أيار", "حزيران",
        "تموز", "آب", "أيلول", "تشرين الأول", "تشرين الثاني", "كانون الأول"
      ];

      final month = monthsAr[dt.month - 1];
      return "${dt.day} $month ${dt.year}";
    } catch (e) {
      return date;
    }
  }
}