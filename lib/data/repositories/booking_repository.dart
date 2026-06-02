

import 'package:hive/hive.dart';
import 'package:dartz/dartz.dart';
import '../models/booking_history_model.dart';
import '../providers/booking_provider.dart';

class BookingRepository {
  final BookingProvider _provider = BookingProvider();

  dynamic _deepConvertValue(dynamic data) {
    if (data is Map) {
      return Map<String, dynamic>.fromEntries(
        data.entries.map((e) => MapEntry(e.key.toString(), _deepConvertValue(e.value))),
      );
    } else if (data is List) {
      return data.map((e) => _deepConvertValue(e)).toList();
    }
    return data;
  }

  Future<Map<String, dynamic>> createBooking({
    required int tripId,
    required List<int> seatNumbers,
    required String paymentMethod,
  }) async {
    final response = await _provider.bookTrip({
      "trip_id": tripId,
      "seats": seatNumbers,
      "payment_method": paymentMethod,
    });
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['data'];
    } else {
      throw Exception("فشل الحجز: ${response.statusMessage}");
    }
  }


  Future<List<BookingHistoryModel>> fetchBookingHistory() async {
    final box = Hive.box('bookings_box');

    final cachedList = box.get('bookings_list');
    List<BookingHistoryModel>? cachedBookings;
    if (cachedList != null && cachedList is List) {
      cachedBookings = cachedList
          .map((item) => BookingHistoryModel.fromJson(_deepConvertValue(item)))
          .toList();
    }

    try {
      final response = await _provider.getBookings();
      if (response.statusCode == 200) {
        final List<dynamic> list = response.data['data'];
        await box.put('bookings_list', list);
        _prefetchBookingDetailsInBackground(list);

        return list
            .map((item) => BookingHistoryModel.fromJson(_deepConvertValue(item)))
            .toList();
      }
    } catch (e) {
      print("فشل جلب البيانات من الشبكة: $e");
    }

    return cachedBookings ?? [];
  }

  void _prefetchBookingDetailsInBackground(List<dynamic> bookings) {
    for (var item in bookings) {
      final id = item['id'];
      if (id != null) {
        _provider.getBookingDetails(id).then((response) {
          if (response.statusCode == 200) {
            final box = Hive.box('bookings_box');
            box.put('booking_detail_$id', response.data['data']);
            print("✅ خلفية: تم حفظ تفاصيل الحجز $id");
          }
        }).catchError((e) {
          print("⚠️ خلفية: فشل حفظ تفاصيل الحجز $id: $e");
        });
      }
    }
  }




  Future<Map<String, dynamic>> fetchBookingDetails(int bookingId) async {
    final box = Hive.box('bookings_box');
    final cacheKey = 'booking_detail_$bookingId';

    try {
      final response = await _provider.getBookingDetails(bookingId);
      if (response.statusCode == 200) {
        final data = response.data['data'];
        await box.put(cacheKey, data);
        return data;
      }
    } catch (e) {
      print("📴 بلا نت");
    }

    final cached = box.get(cacheKey);

    // ✅ أضيفي هذا للتشخيص
    print("🔍 cached type: ${cached.runtimeType}");
    print("🔍 cached value: $cached");

    if (cached != null) {
      return _deepConvertValue(cached) as Map<String, dynamic>;
    }

    throw Exception("لا يوجد إنترنت ولا بيانات محفوظة لهذا الحجز");
  }
}