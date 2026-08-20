import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:dartz/dartz.dart';
import '../models/booking_history_model.dart';
import '../providers/booking_provider.dart';

class BookingRepository {
  final BookingProvider provider = BookingProvider();

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

  Future<Map<String, dynamic>> validateBooking({
    required int tripId,
    required List<int> seatNumbers,
    required String paymentMethod,
    int? subscriptionId,
  }) async {
    final response = await provider.calculateBooking({
      "trip_id": tripId,
      "seat_numbers": seatNumbers,
      "payment_method": paymentMethod,
      "payment_currency": "SYP",
      if (subscriptionId != null) "user_subscription_id": subscriptionId,
    });

    if (response.statusCode == 200) {
      return response.data;
    } else {
      final message = response.data is Map
          ? response.data['message'] ?? "فشل التحقق من الحجز"
          : "فشل التحقق من الحجز";
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> createBooking({
    required int tripId,
    required List<int> seatNumbers,
    required String paymentMethod,
    int? subscriptionId,
  }) async {
    final Map<String, dynamic> data = {
      "trip_id": tripId,
      "seat_numbers": seatNumbers,
      "payment_method": paymentMethod,
      "payment_currency": "SYP",
    };

    if (subscriptionId != null) {
      data["user_subscription_id"] = subscriptionId;
    }

    final response = await provider.bookTrip(data);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['data'];
    } else {
      throw Exception(response.data['message'] ?? "فشل الحجز");
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
      final response = await provider.getBookings();
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
        provider.getBookingDetails(id).then((response) {
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
      final response = await provider.getBookingDetails(bookingId);
      if (response.statusCode == 200) {
        final data = response.data['data'];
        await box.put(cacheKey, data);
        print('✅ Fetched fresh data for booking $bookingId');
        return data;
      }
    } catch (e) {
      print("📴 بلا نت - using cache");
    }

    final cached = box.get(cacheKey);
    print("🔍 Using cached data for booking $bookingId");

    if (cached != null) {
      return _deepConvertValue(cached) as Map<String, dynamic>;
    }

    throw Exception("لا يوجد إنترنت ولا بيانات محفوظة لهذا الحجز");
  }

  Future<Map<String, dynamic>> payForChildBooking({
    required int childBookingId,
    required String paymentMethod,
    required String paymentCurrency,
  }) async {
    final response = await provider.payChildBooking(childBookingId, {
      "payment_method": paymentMethod,
      "payment_currency": paymentCurrency,
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      throw Exception(response.data['message'] ?? "فشل دفع الحجز الفرعي");
    }
  }

  Future<Map<String, dynamic>> modifyBookingSeats({
    required int bookingId,
    required List<int> newSeats,
  }) async {
    final response = await provider.modifyBooking({
      "booking_id": bookingId,
      "new_seats": newSeats,
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      final message = response.data is Map
          ? response.data['message'] ?? "failed_modify_seats".tr
          : "failed_modify_seats".tr;
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> cancelBooking(int bookingId) async {
    final response = await provider.cancelBooking(bookingId);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data;
    } else {
      final message = response.data is Map
          ? response.data['message'] ?? "failed_cancel_booking".tr
          : "failed_cancel_booking".tr;
      throw Exception(message);
    }
  }

  Future<void> clearBookingCache() async {
    try {
      final box = Hive.box('bookings_box');

      await box.delete('bookings_list');

      final keys = box.keys.toList();
      for (var key in keys) {
        if (key.toString().startsWith('booking_detail_')) {
          await box.delete(key);
        }
      }

      print('✅ Booking cache cleared completely');
    } catch (e) {
      print('Error clearing booking cache: $e');
    }
  }

  Future<List<String>> fetchAllMergedSeatsForTrip(int tripId, {int? extraBookingId}) async {
    try {
      final allBookings = await fetchBookingHistory();

      final relatedIds = <int>{
        ...allBookings
            .where((b) => b.tripId == tripId && b.status.toLowerCase() != 'cancelled')
            .map((b) => b.id),
        if (extraBookingId != null) extraBookingId,
      };

      final Set<String> mergedSeats = {};

      for (final id in relatedIds) {
        try {
          final details = await fetchBookingDetails(id);
          final rawSeats = details['seat_numbers'];

          if (rawSeats is List) {
            for (final s in rawSeats) {
              final clean = s.toString().trim();
              if (clean.isNotEmpty) mergedSeats.add(clean);
            }
          }
        } catch (e) {
          print('fetchAllMergedSeatsForTrip error for booking $id: $e');
        }
      }

      final result = mergedSeats.toList();
      print('📌 All merged seats: $result');
      return result;
    } catch (e) {
      print('Error fetching all merged seats: $e');
      return [];
    }
  }

  Future<List<String>> fetchLatestConfirmedSeatsForTrip(int tripId, {int? extraBookingId}) async {
    try {
      final allBookings = await fetchBookingHistory();

      final tripBookings = allBookings
          .where((b) => b.tripId == tripId && b.status.toLowerCase() != 'cancelled')
          .toList();

      if (tripBookings.isEmpty) {
        return [];
      }

      tripBookings.sort((a, b) => b.id.compareTo(a.id));

      BookingHistoryModel? latestConfirmed;
      for (final booking in tripBookings) {
        if (booking.status.toLowerCase() == 'confirmed') {
          latestConfirmed = booking;
          break;
        }
      }

      final targetBooking = latestConfirmed ?? tripBookings.first;

      print('📌 Using booking: ${targetBooking.id} (${targetBooking.status})');

      final details = await fetchBookingDetails(targetBooking.id);
      final rawSeats = details['seat_numbers'];

      if (rawSeats is List) {
        final seats = rawSeats
            .map((s) => s.toString().trim())
            .where((s) => s.isNotEmpty)
            .toList();
        print('📌 Seats from latest confirmed booking: $seats');
        return seats;
      }

      return [];
    } catch (e) {
      print('Error fetching latest confirmed seats: $e');
      return [];
    }
  }
}