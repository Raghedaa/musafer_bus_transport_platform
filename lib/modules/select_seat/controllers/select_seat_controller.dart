
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../core/shared/custom_snackbar.dart';
import '../../../data/models/booking_summary_model.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/trip_repository.dart';

import '../../booking_history/controllers/booking_history_controller.dart';
import '../../booking_summary/controllers/booking_summary_controller.dart';
import '../../booking_summary/view/screen/booking_summary_screen.dart';
import '../../main_layout/controller/main_layout_controller.dart';
import '../../profile/controller/profile_controller.dart';
import '../../ticket_details/controllers/ticket_controller.dart';

enum SeatDisplayType {
  available,
  selectedNew,
  myOriginalSelected,
  myOriginalDeselected,
  bookedByOthers,
}

class SelectSeatController extends GetxController {
  static TripModel? staticTrip;
  static int? currentBookingId;
  static bool isNavigating = false;

  bool isModifyMode = false;

  final TripRepository tripRepository = TripRepository();
  final BookingRepository bookingRepository = BookingRepository();

  final isLoading = true.obs;
  final isLoadingError = false.obs;
  final isSubmitting = false.obs;

  final vehicleModel = Rxn<VehicleModel>();
  final selectedSeats = <String>[].obs;
  final hasVehicleData = true.obs;

  final totalPrice = 0.0.obs;
  final extraPrice = 0.0.obs;

  final List<String> originalSeats = [];


  String _cleanSeat(dynamic value) {
    return value.toString().trim();
  }

  bool _containsSeat(Iterable<String> seats, String seat) {
    final cleanSeat = _cleanSeat(seat);
    return seats.any((item) => _cleanSeat(item) == cleanSeat);
  }

  List<String> _cleanSeats(Iterable<dynamic> seats) {
    final result = <String>[];
    for (final seat in seats) {
      final cleanSeat = _cleanSeat(seat);
      if (cleanSeat.isEmpty) continue;
      if (!result.contains(cleanSeat)) {
        result.add(cleanSeat);
      }
    }
    return result;
  }

  Future<List<String>> _fetchAllMySeatsForTrip(int tripId) async {
    try {
      final seats = await bookingRepository.fetchAllMergedSeatsForTrip(
        tripId,
        extraBookingId: currentBookingId,
      );
      return seats;
    } catch (e) {
      debugPrint('_fetchAllMySeatsForTrip error: $e');
      return [];
    }
  }


  @override
  void onInit() {
    super.onInit();

    _resetState();

    if (staticTrip != null) {
      _loadVehicleData();
    } else {
      _setErrorState('لا توجد بيانات للرحلة');
    }
  }

  void _resetState() {
    isLoading.value = true;
    isLoadingError.value = false;
    hasVehicleData.value = false;
    isModifyMode = false;
    selectedSeats.clear();
    originalSeats.clear();
    vehicleModel.value = null;
    totalPrice.value = 0.0;
    extraPrice.value = 0.0;
  }

  void _setErrorState(String message) {
    isLoading.value = false;
    isLoadingError.value = true;
    hasVehicleData.value = false;
    debugPrint('❌ Error: $message');
  }

  void _loadVehicleData() {
    try {
      final vehicleData = staticTrip!.rawVehicle;
      final seatMapData = staticTrip!.rawSeatMap;

      if (vehicleData != null &&
          vehicleData.isNotEmpty &&
          seatMapData != null &&
          seatMapData.isNotEmpty) {
        vehicleModel.value = VehicleModel.fromJson(vehicleData, seatMapData);
        hasVehicleData.value = true;
        isLoading.value = false;
        isLoadingError.value = false;
        debugPrint('✅ Vehicle data loaded successfully');
      } else {
        debugPrint('⚠️ rawVehicle or rawSeatMap is empty, fetching from server...');
        fetchVehicleDataFromServer(staticTrip!.id);
      }
    } catch (e) {
      debugPrint('❌ VehicleModel onInit error: $e');
      if (staticTrip != null) {
        fetchVehicleDataFromServer(staticTrip!.id);
      } else {
        _setErrorState('خطأ في تحميل بيانات المركبة');
      }
    }
  }

  Future<void> fetchVehicleDataFromServer(int tripId) async {
    try {
      isLoading.value = true;
      isLoadingError.value = false;

      final tripData = await tripRepository.fetchTripDetails(tripId);

      if (tripData.rawVehicle.isNotEmpty && tripData.rawSeatMap.isNotEmpty) {
        vehicleModel.value = VehicleModel.fromJson(
          tripData.rawVehicle,
          tripData.rawSeatMap,
        );
        staticTrip = tripData;
        hasVehicleData.value = true;
        isLoadingError.value = false;
        debugPrint('✅ Vehicle data fetched from server successfully');
      } else {
        debugPrint('❌ Server returned empty vehicle data for trip $tripId');
        _setErrorState('لا توجد بيانات للمركبة لهذه الرحلة');
        CustomSnackBar.showError('لا توجد بيانات للمركبة لهذه الرحلة');
      }
    } catch (e) {
      debugPrint('❌ Failed to fetch vehicle data from server: $e');
      _setErrorState('حدث خطأ أثناء تحميل بيانات المركبة');
      CustomSnackBar.showError('حدث خطأ أثناء تحميل بيانات المركبة');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    isModifyMode = false;
    originalSeats.clear();
    selectedSeats.clear();
    vehicleModel.value = null;
    super.onClose();
  }

  void initWithModifyMode({
    required TripModel trip,
    required int bookingId,
    List<String> originalSeatsList = const [],
  }) {
    debugPrint('🔧 Initializing modify mode...');

    isModifyMode = true;
    staticTrip = trip;
    currentBookingId = bookingId;

    originalSeats
      ..clear()
      ..addAll(_cleanSeats(originalSeatsList));

    selectedSeats
      ..clear()
      ..addAll(originalSeats);

    debugPrint('ORIGINAL SEATS (INITIAL GUESS): $originalSeats');

    isLoading.value = true;
    isLoadingError.value = false;
    hasVehicleData.value = false;

    _fetchVehicleDataFromServerWithCallback(trip.id, () {
      _recalculatePrices();
      _initModifySequenced(trip.id);
    });
  }

  Future<void> _fetchVehicleDataFromServerWithCallback(int tripId, VoidCallback onSuccess) async {
    try {
      isLoading.value = true;
      debugPrint('🔄 Fetching fresh vehicle data for trip $tripId...');

      final tripData = await tripRepository.fetchTripDetails(tripId);

      if (tripData.rawVehicle.isNotEmpty && tripData.rawSeatMap.isNotEmpty) {
        vehicleModel.value = VehicleModel.fromJson(
          tripData.rawVehicle,
          tripData.rawSeatMap,
        );
        staticTrip = tripData;
        hasVehicleData.value = true;
        isLoadingError.value = false;
        debugPrint('✅ Vehicle data fetched from server successfully');
        onSuccess();
      } else {
        debugPrint('❌ Server returned empty vehicle data for trip $tripId');
        _setErrorState('لا توجد بيانات للمركبة لهذه الرحلة');
        CustomSnackBar.showError('لا توجد بيانات للمركبة لهذه الرحلة');
      }
    } catch (e) {
      debugPrint('❌ Failed to fetch vehicle data from server: $e');
      _setErrorState('حدث خطأ أثناء تحميل بيانات المركبة');
      CustomSnackBar.showError('حدث خطأ أثناء تحميل بيانات المركبة');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _initModifySequenced(int tripId) async {
    await _refreshRealOriginalSeats(tripId);
    await fetchSeatsData();
  }

  Future<void> _refreshRealOriginalSeats(int tripId) async {
    final realSeats = await _fetchAllMySeatsForTrip(tripId);
    if (realSeats.isEmpty) return;

    originalSeats
      ..clear()
      ..addAll(realSeats);

    for (final seat in realSeats) {
      if (!_containsSeat(selectedSeats, seat)) {
        selectedSeats.add(seat);
      }
    }

    _recalculatePrices();

    debugPrint('ORIGINAL SEATS (REAL FROM SERVER): $originalSeats');
    debugPrint('SELECTED SEATS AFTER REAL SYNC: ${selectedSeats.toList()}');
  }

  void _recalculatePrices() {
    final pricePerSeat = staticTrip?.price ?? 0.0;
    totalPrice.value = selectedSeats.length * pricePerSeat;

    if (!isModifyMode) {
      extraPrice.value = totalPrice.value;
      return;
    }

    final addedSeats = selectedSeats.where(
          (seat) => !_containsSeat(originalSeats, seat),
    );

    final removedSeats = originalSeats.where(
          (seat) => !_containsSeat(selectedSeats, seat),
    );

    final addedCount = addedSeats.length;
    final removedCount = removedSeats.length;
    final netExtraSeats = addedCount - removedCount;

    extraPrice.value = netExtraSeats > 0 ? netExtraSeats * pricePerSeat : 0.0;

    debugPrint(
      'PRICE => selected: ${selectedSeats.toList()}, '
          'added: $addedCount, removed: $removedCount, '
          'extra: ${extraPrice.value}',
    );
  }

  // ============================================================
  // 🔹 جلب بيانات المقاعد من السيرفر
  // ============================================================

  Future<void> fetchSeatsData() async {
    final trip = staticTrip;
    if (trip == null) {
      debugPrint('fetchSeatsData: staticTrip is null');
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;
      final newTripData = await tripRepository.fetchTripDetails(trip.id);

      final newVehicle = VehicleModel.fromJson(
        newTripData.rawVehicle,
        newTripData.rawSeatMap,
      );

      final selectedSnapshot = List<String>.from(selectedSeats);

      for (final selectedSeat in selectedSnapshot) {
        final cleanSeat = _cleanSeat(selectedSeat);

        final seatInServer = newVehicle.seats.firstWhereOrNull(
              (seat) => _cleanSeat(seat.label) == cleanSeat,
        );

        final isMyOriginalSeat = _containsSeat(originalSeats, cleanSeat);

        if (seatInServer != null &&
            seatInServer.status == 3 &&
            !isMyOriginalSeat) {
          selectedSeats.removeWhere(
                (seat) => _cleanSeat(seat) == cleanSeat,
          );

          CustomSnackBar.showError(
            'seatbooked_by_another'.trParams({
              'seatNumber': cleanSeat,
            }),
          );
        }
      }

      vehicleModel.value = newVehicle;
      hasVehicleData.value = true;
      isLoadingError.value = false;
      _recalculatePrices();

      debugPrint('SELECTED SEATS AFTER FETCH: ${selectedSeats.toList()}');
    } catch (e) {
      debugPrint('fetchSeatsData error: $e');
      CustomSnackBar.showError('failed_update_seats'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // 🔹 نوع عرض المقعد
  // ============================================================

  SeatDisplayType getSeatDisplayType(String label, int? seatStatus) {
    final cleanLabel = _cleanSeat(label);
    final isSelected = _containsSeat(selectedSeats, cleanLabel);
    final isOriginal = _containsSeat(originalSeats, cleanLabel);

    if (isModifyMode && isSelected) {
      return SeatDisplayType.myOriginalSelected;
    }

    if (isModifyMode && isOriginal && !isSelected) {
      return SeatDisplayType.myOriginalDeselected;
    }

    if (!isModifyMode && isSelected) {
      return SeatDisplayType.selectedNew;
    }

    if (seatStatus == 3) {
      return SeatDisplayType.bookedByOthers;
    }

    return SeatDisplayType.available;
  }


  void toggleSeat(String label) {
    final cleanLabel = _cleanSeat(label);

    final seat = vehicleModel.value?.seats.firstWhereOrNull(
          (item) => _cleanSeat(item.label) == cleanLabel,
    );

    final isOriginalSeat = _containsSeat(originalSeats, cleanLabel);
    final isCurrentlySelected = _containsSeat(selectedSeats, cleanLabel);

    if (seat != null &&
        seat.status == 3 &&
        !isOriginalSeat &&
        !isCurrentlySelected) {
      CustomSnackBar.showError(
        'seatbooked_by_another'.trParams({
          'seatNumber': cleanLabel,
        }),
      );
      return;
    }

    if (isCurrentlySelected) {
      selectedSeats.removeWhere(
            (item) => _cleanSeat(item) == cleanLabel,
      );
    } else {
      selectedSeats.add(cleanLabel);
    }

    _recalculatePrices();

    debugPrint('SEAT TOGGLE => ${selectedSeats.toList()}');
  }

  String getSeatLabel(int row, int col) {
    final seat = vehicleModel.value?.seats.firstWhereOrNull(
          (item) => item.rowIndex == row && item.columnIndex == col,
    );
    return seat?.label ?? '';
  }

  // ============================================================
  // 🔹 تنفيذ الإجراء (حجز أو تعديل)
  // ============================================================

  void handleAction() {
    if (selectedSeats.isEmpty) {
      CustomSnackBar.showError('select_at_least_one'.tr);
      return;
    }

    if (!isModifyMode) {
      goToPayment();
      return;
    }

    final originalSet = originalSeats.toSet();
    final selectedSet = selectedSeats.toSet();

    final hasNoChanges = originalSet.length == selectedSet.length &&
        originalSet.containsAll(selectedSet) &&
        selectedSet.containsAll(originalSet);

    if (hasNoChanges) {
      CustomSnackBar.showError('no_changes_made'.tr);
      return;
    }

    executeModifyBooking();
  }


  Future<void> executeModifyBooking() async {
    final bookingId = currentBookingId;

    if (bookingId == null) {
      CustomSnackBar.showError('failed_update_seats'.tr);
      return;
    }

    try {
      isSubmitting.value = true;

      final finalSeats = _cleanSeats(selectedSeats);

      final seatNumbers = finalSeats
          .map((seat) => int.tryParse(seat))
          .whereType<int>()
          .toList();

      if (seatNumbers.isEmpty) {
        CustomSnackBar.showError('select_at_least_one'.tr);
        return;
      }

      debugPrint('SENDING FINAL SEATS TO SERVER: $seatNumbers');

      final result = await bookingRepository.modifyBookingSeats(
        bookingId: bookingId,
        newSeats: seatNumbers,
      );

      debugPrint('MODIFY RESPONSE: $result');

      final childBookingId = result['data']?['child_booking_id'] ??
          result['child_booking_id'];

      final serverPrice = result['data']?['price_to_pay'] ??
          result['price_to_pay'];

      double amount = 0.0;

      if (serverPrice is num) {
        amount = serverPrice.toDouble();
      } else {
        amount = extraPrice.value;
      }

      if (childBookingId != null && amount > 0) {
        isSubmitting.value = false;
        await showPaymentConfirmationDialog(
          childBookingId: int.parse(childBookingId.toString()),
          amount: amount,
        );
      } else {
        CustomSnackBar.showSuccess('seatsupdated_successfully'.tr);
        await finalizeModification(finalSeats: finalSeats);
      }
    } catch (e) {
      debugPrint('MODIFY BOOKING ERROR: $e');
      handleError(e);
    } finally {
      isSubmitting.value = false;
    }
  }


  Future<void> showPaymentConfirmationDialog({
    required int childBookingId,
    required double amount,
  }) async {
    bool isPaying = false;

    await Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              'confirm_modification'.tr,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('modification_requires_extra_payment'.tr),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${'amount_due'.tr}:'),
                    Text(
                      '${amount.toStringAsFixed(2)} SYP',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'pay_from_wallet_confirm'.tr,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isPaying ? null : () => Get.back(),
                child: Text(
                  'cancel'.tr,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: isPaying
                    ? null
                    : () async {
                  try {
                    setDialogState(() => isPaying = true);

                    await bookingRepository.payForChildBooking(
                      childBookingId: childBookingId,
                      paymentMethod: 'wallet',
                      paymentCurrency: 'SYP',
                    );

                    Get.back();

                    CustomSnackBar.showSuccess(
                      'seats_updated_and_paid_successfully'.tr,
                    );

                    await finalizeModification(
                      finalSeats: _cleanSeats(selectedSeats),
                    );
                  } catch (e) {
                    setDialogState(() => isPaying = false);
                    CustomSnackBar.showError(
                      e.toString().replaceAll('Exception:', ''),
                    );
                  }
                },
                child: isPaying
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text('pay_now'.tr),
              ),
            ],
          );
        },
      ),
      barrierDismissible: false,
    );
  }


  Future<void> finalizeModification({
    required List<String> finalSeats,
  }) async {
    final cleanFinalSeats = _cleanSeats(finalSeats);

    debugPrint('FINAL SEATS AFTER PAYMENT: $cleanFinalSeats');

    // ✅ تحديث التذكرة محلياً
    if (Get.isRegistered<TicketController>()) {
      final ticketController = Get.find<TicketController>();
      ticketController.updateSeatsLocally(cleanFinalSeats);
      ticketController.update();
    }

    if (Get.isRegistered<ProfileController>()) {
      await Get.find<ProfileController>().fetchData();
    }

    try {
      final box = Hive.box('bookings_box');
      await box.delete('bookings_list');

      final keys = box.keys
          .where((key) => key.toString().startsWith('booking_detail_'));
      for (var key in keys) {
        await box.delete(key);
      }
      debugPrint('✅ Cache cleared successfully');
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }

    if (Get.isRegistered<BookingHistoryController>()) {
      final historyCtrl = Get.find<BookingHistoryController>();
      await historyCtrl.fetchBookings();
    }

    isModifyMode = false;
    currentBookingId = null;
    selectedSeats.clear();

    final layoutController = Get.find<MainLayoutController>();
    if (layoutController.bookingStack.length > 1) {
      if (Get.isRegistered<SelectSeatController>()) {
        Get.delete<SelectSeatController>(force: true);
      }
      layoutController.popBookings();
    }
  }

  void handleError(dynamic e) {
    String errorMessage = 'failed_update_seats'.tr;

    if (e is dio.DioException && e.response?.data != null) {
      final responseData = e.response!.data;

      if (responseData is Map) {
        if (responseData['errors'] is Map) {
          final errors = responseData['errors'] as Map;

          if (errors.values.isNotEmpty) {
            final firstError = errors.values.first;

            if (firstError is List && firstError.isNotEmpty) {
              errorMessage = firstError.first.toString();
            } else {
              errorMessage = firstError.toString();
            }
          }
        } else if (responseData['message'] != null) {
          errorMessage = responseData['message'].toString();
        }
      }
    } else {
      errorMessage = e.toString().replaceAll('Exception:', '').trim();
    }

    CustomSnackBar.showError(errorMessage);
  }


  void goToPayment() {
    final trip = staticTrip;

    if (trip == null) return;

    final summaryModel = BookingSummaryModel(
      tripDetails: trip,
      selectedSeats: _cleanSeats(selectedSeats),
      pnrNumber: 'PENDING',
      totalPrice: totalPrice.value,
      bookingDate: DateTime.now(),
    );

    if (Get.isRegistered<BookingSummaryController>()) {
      Get.delete<BookingSummaryController>();
    }

    final summaryController = Get.put(BookingSummaryController());
    summaryController.bookingSummaryModel.value = summaryModel;

    Get.find<MainLayoutController>().pushToExplore(
      const BookingSummaryScreen(),
    );
  }
}