import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:pusher_client_socket/pusher_client_socket.dart';
import 'package:pusher_client_socket/channels/private_channel.dart';

import '../../../core/services/api_service.dart';
import '../../../data/models/rest_area_model.dart';
import '../../../data/models/station_model.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/repositories/trip_repository.dart';
import '../../../data/repositories/tracking_repository.dart';
import '../../../core/shared/custom_snackbar.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../booking_history/controllers/booking_history_controller.dart';
import '../../booking_history/view/screen/booking_history_screen.dart';
import '../../main_layout/controller/main_layout_controller.dart';
import '../view/widget/trip_rating_dialog.dart';

class TripTrackingController extends GetxController with GetTickerProviderStateMixin {
  final int tripId;
  TripTrackingController({required this.tripId});

  var isMapReady = false.obs;
  var isLoading = true.obs;
  var polylinePoints = <LatLng>[].obs;
  var markers = <Marker>[].obs;
  var hasError = false.obs;

  var busLocation = Rxn<LatLng>();
  var myLocation = Rxn<LatLng>();

  late MapController mapController;
  late AnimationController _animController;

  Animation<double>? _latAnim;
  Animation<double>? _lngAnim;
  LatLng? _previousBusLocation;

  PusherClient? _pusher;
  PrivateChannel? _channel;

  GlobalKey<State>? dialogKey;
  BuildContext? screenContext;

  var isSocketConnected = false.obs;

  final TrackingRepository _trackingRepo = TrackingRepository();

  var tripStatus = ''.obs;
  String? _previousStatus;
  bool _ratingDialogShown = false;

  int? _bookingId;
  int? _companyId;
  int? _driverId;
  String? _companyName;
  String? _driverName;

  Timer? _predictionTimer;
  DateTime? _lastPingTime;
  double? _lastSpeed;
  double? _lastHeading;
  var isBusOffline = false.obs;

  static const int _offlineThresholdSeconds = 45;

  var isSubmittingReview = false.obs;

  Timer? _statusPollingTimer;
  bool _isPolling = false;

  static const String _reverbAppKey = 'e9a5f51fc0b862fce239d3a58fa02adc';
  static const String _reverbHost = 'syria-travel.app';
  static const String _authEndpoint =
      'https://syria-travel.app/api/broadcasting/auth';

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    if (!Get.isRegistered<BookingHistoryController>()) {
      Get.put(BookingHistoryController());
    }

    _listenToBookingUpdates();
    fetchTripDetails().then((_) => _connectWebSocket());

    _startStatusPolling();

    final apiService = Get.find<ApiService>();
    ever(apiService.isConnected, (bool connected) {
      if (connected && hasError.value) {
        retryLoading();
      }
    });
  }

  void _startStatusPolling() {
    _statusPollingTimer?.cancel();
    _statusPollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _checkTripStatusOnly();
    });
  }

  Future<void> _checkTripStatusOnly() async {
    if (_ratingDialogShown) {
      _statusPollingTimer?.cancel();
      return;
    }

    if (_isPolling) return;
    _isPolling = true;

    try {
      final repo = Get.find<TripRepository>();

      final response = await repo.fetchTripDetails(tripId);

      final String currentStatus = response.status;

      print('📊 [POLLING] حالة الرحلة الحالية: $currentStatus');

      if (currentStatus.toLowerCase() == 'completed' && !_ratingDialogShown) {
        print('🔵🔵🔵 [POLLING] الرحلة اكتملت!');
        _onTripCompleted();
        _statusPollingTimer?.cancel();
      }

      tripStatus.value = currentStatus;

    } catch (e) {
    } finally {
      _isPolling = false;
    }
  }

  void _listenToBookingUpdates() {
    try {
      final bookingCtrl = Get.find<BookingHistoryController>();
      ever(bookingCtrl.allBookings, (_) {
        _checkBookingStatus();
      });
      print('✅ [BOOKING] Successfully listening to booking updates');
    } catch (e) {
      print('⚠️ [BOOKING] BookingHistoryController not found, will retry...');
      Future.delayed(const Duration(seconds: 1), () {
        _listenToBookingUpdates();
      });
    }
  }

  void _checkBookingStatus() {
    try {
      final bookingCtrl = Get.find<BookingHistoryController>();
      final booking = bookingCtrl.allBookings.firstWhereOrNull(
              (b) => b.tripId == tripId
      );

      if (booking != null) {
        print('🔵 [BOOKING CHECK] Booking ID: ${booking.id}, Status: ${booking.status}, Trip Status: ${booking.tripStatus}');

        if (booking.tripStatus.toLowerCase() == 'completed' && !_ratingDialogShown) {
          print('🔵🔵🔵 [BOOKING CHECK] Trip completed! Showing rating dialog...');
          _onTripCompleted();
          _statusPollingTimer?.cancel();
        }
      }
    } catch (e) {
      debugPrint('❌ Error checking booking status: $e');
    }
  }

  @override
  void onClose() {
    _statusPollingTimer?.cancel();
    _animController.dispose();
    _predictionTimer?.cancel();
    _disconnectWebSocket();
    mapController.dispose();
    super.onClose();
  }

  Future<void> retryLoading() async {
    hasError.value = false;
    await fetchTripDetails();
    if (!isSocketConnected.value) {
      _connectWebSocket();
    }
  }

  void _startPredictionTimer() {
    _predictionTimer?.cancel();
    _predictionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_lastPingTime == null || busLocation.value == null) return;

      final secondsSinceLastPing = DateTime.now().difference(_lastPingTime!).inSeconds;

      if (secondsSinceLastPing >= _offlineThresholdSeconds) {
        isBusOffline.value = true;
        debugPrint('⚠️ [${secondsSinceLastPing}s] الباص غير متصل، نقوم بالتوقع...');

        if (_lastSpeed != null && _lastSpeed! > 0.3 && _lastHeading != null) {
          final newPos = _extrapolatePosition(
            from: busLocation.value!,
            speedMetersPerSecond: _lastSpeed!,
            headingDegrees: _lastHeading!,
            seconds: 1,
          );
          busLocation.value = newPos;
          debugPrint('📍 الموقع المتوقع: (${newPos.latitude}, ${newPos.longitude})');
        }
      } else {
        debugPrint('⏱️ باقي ${_offlineThresholdSeconds - secondsSinceLastPing} ثانية للانقطاع');
      }
    });
  }

  LatLng _extrapolatePosition({
    required LatLng from,
    required double speedMetersPerSecond,
    required double headingDegrees,
    required int seconds,
  }) {
    const double earthRadius = 6371000;
    final double distance = speedMetersPerSecond * seconds;
    final double headingRad = headingDegrees * (math.pi / 180);
    final double lat1 = from.latitude * (math.pi / 180);
    final double lng1 = from.longitude * (math.pi / 180);

    final double lat2 = math.asin(
      math.sin(lat1) * math.cos(distance / earthRadius) +
          math.cos(lat1) * math.sin(distance / earthRadius) * math.cos(headingRad),
    );
    final double lng2 = lng1 + math.atan2(
      math.sin(headingRad) * math.sin(distance / earthRadius) * math.cos(lat1),
      math.cos(distance / earthRadius) - math.sin(lat1) * math.sin(lat2),
    );

    return LatLng(lat2 * (180 / math.pi), lng2 * (180 / math.pi));
  }

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  void _connectWebSocket() {
    try {
      final String token = GetStorage().read('token') ?? '';
      if (token.isEmpty) {
        debugPrint('❌ لا يوجد توكن، تعذر فتح السوكيت');
        return;
      }

      _pusher = PusherClient(
        options: PusherOptions(
          key: _reverbAppKey,
          host: _reverbHost,
          wsPort: 443,
          encrypted: true,
          authOptions: PusherAuthOptions(
            _authEndpoint,
            headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
          ),
          autoConnect: false,
        ),
      );

      _pusher!.onConnectionStateChange((state) {
        debugPrint('🔌 Pusher connection state changed: $state');
        isSocketConnected.value = state.toString().toLowerCase().contains('connected');
      });

      _pusher!.onError((error) {
        debugPrint('❌ Pusher error: $error');
      });

      _pusher!.connect();

      final channel = _pusher!.subscribe('private-trip.$tripId.tracking');

      if (channel is PrivateChannel) {
        _channel = channel;

        _channel!.bind('pusher:subscription_succeeded', (dynamic data) {
          debugPrint('✅ تم الاشتراك فعلياً بقناة: private-trip.$tripId.tracking');
          _startPredictionTimer();
        });

        _channel!.bind('pusher:subscription_error', (dynamic data) {
          debugPrint('❌ فشل الاشتراك بالقناة: $data');
        });

        _channel!.bind('Modules\\Operations\\Events\\TripLocationUpdated', (dynamic event) {
          debugPrint('📡 [موقع الباص - namespaced] $event');
          _handleLocationEvent(event);
        });
        _channel!.bind('TripLocationUpdated', (dynamic event) {
          debugPrint('📡 [موقع الباص - short] $event');
          _handleLocationEvent(event);
        });

        _channel!.bind('Modules\\Operations\\Events\\TripStatusUpdated', (dynamic event) {
          debugPrint('📡 [حالة الرحلة - namespaced] $event');
          _handleStatusEvent(event);
        });
        _channel!.bind('TripStatusUpdated', (dynamic event) {
          debugPrint('📡 [حالة الرحلة - short] $event');
          _handleStatusEvent(event);
        });

        debugPrint('🔄 تم إرسال طلب الاشتراك، بانتظار تأكيد pusher:subscription_succeeded ...');
      } else {
        debugPrint('❌ فشل إنشاء PrivateChannel');
      }
    } catch (e) {
      debugPrint('❌ فشل في تهيئة WebSocket: $e');
    }
  }

  void _disconnectWebSocket() {
    try {
      _predictionTimer?.cancel();
      _predictionTimer = null;

      _channel?.unbind('Modules\\Operations\\Events\\TripLocationUpdated');
      _channel?.unbind('Modules\\Operations\\Events\\TripStatusUpdated');
      _channel?.unbind('TripLocationUpdated');
      _channel?.unbind('TripStatusUpdated');
      _channel?.unbind('pusher:subscription_succeeded');
      _channel?.unbind('pusher:subscription_error');
      _pusher?.disconnect();
      _pusher = null;
      _channel = null;
      isSocketConnected.value = false;
      debugPrint('🔌 تم إغلاق اتصال الـ WebSocket بأمان');
    } catch (e) {
      debugPrint('Error disconnecting: $e');
    }
  }

  void _handleLocationEvent(dynamic eventData) {
    try {
      final Map<String, dynamic> locationData = (eventData is Map)
          ? Map<String, dynamic>.from(eventData)
          : jsonDecode(eventData.toString());

      final double lat = double.parse(locationData['lat'].toString());
      final double lng = double.parse(locationData['lng'].toString());
      final double? speed = locationData['speed'] != null
          ? double.tryParse(locationData['speed'].toString()) : null;
      final double? heading = locationData['heading'] != null
          ? double.tryParse(locationData['heading'].toString()) : null;

      debugPrint('📊 السرعة: $speed م/ث | الاتجاه: $heading°');

      _lastPingTime = DateTime.now();
      if (speed != null) _lastSpeed = speed;
      if (heading != null) _lastHeading = heading;

      debugPrint('✅ تم استلام بينغ جديد من الباص!');

      if (isBusOffline.value) {
        debugPrint('🔄 الباص كان غير متصل، الآن رجع!');
      }

      isBusOffline.value = false;
      _animateBusTo(LatLng(lat, lng));

      if (locationData['status'] != null) {
        final String status = locationData['status'].toString();
        if (status.toLowerCase() == 'completed' && !_ratingDialogShown) {
          print('🔵🔵🔵 [WEBSOCKET] Trip completed! Showing rating dialog...');
          _onTripCompleted();
          _statusPollingTimer?.cancel();
        }
        tripStatus.value = status;
      }
    } catch (e) {
      debugPrint('❌ خطأ في معالجة بيانات الموقع من السوكيت: $e');
    }
  }

  void _handleStatusEvent(dynamic eventData) {
    try {
      final Map<String, dynamic> data = (eventData is Map)
          ? Map<String, dynamic>.from(eventData)
          : jsonDecode(eventData.toString());

      final status = data['status']?.toString() ?? '';
      if (status.isNotEmpty) {
        tripStatus.value = status;
        if (status.toLowerCase() == 'completed' && !_ratingDialogShown) {
          print('🔵🔵🔵 [STATUS EVENT] Trip completed! Showing rating dialog...');
          _onTripCompleted();
          _statusPollingTimer?.cancel();
        }
      }
    } catch (e) {
      debugPrint('❌ خطأ في معالجة حالة الرحلة من السوكيت: $e');
    }
  }

  void _onTripCompleted() {
    print('🔵🔵🔵 [_onTripCompleted] STARTED');
    print('🔵 _ratingDialogShown = $_ratingDialogShown');

    if (_ratingDialogShown) {
      print('🔵 _ratingDialogShown is true, returning');
      return;
    }

    _ratingDialogShown = true;
    print('✅ _ratingDialogShown set to true');

    print('🔵 Stopping animation...');
    _animController.stop();

    print('🔵 Disconnecting websocket...');
    _disconnectWebSocket();

    print('🔵 Calling _showRatingDialog...');
    _showRatingDialog();
  }

  void _showRatingDialog() {
    print('🔵🔵🔵 [_showRatingDialog] STARTED');
    print('🔵 Get.isDialogOpen = ${Get.isDialogOpen}');
    print('🔵 screenContext = $screenContext');
    print('🔵 screenContext?.mounted = ${screenContext?.mounted}');

    if (Get.isDialogOpen ?? false) {
      print('⚠️ Dialog already open, returning');
      return;
    }

    print('🔵 companyName = $_companyName');
    print('🔵 driverName = $_driverName');

    if (screenContext != null && screenContext!.mounted) {
      print('🔵 Using screenContext to show dialog');
      try {
        showDialog(
          context: screenContext!,
          barrierDismissible: false,
          builder: (context) {
            return TripRatingDialog(
              companyName: _companyName,
              driverName: _driverName,
              onCancel: () {
                print('🔵 onCancel called');
                _navigateToBookingsWithCompletedTab();
              },
              onSubmit: submitReview,
            );
          },
        );
        print('🔵 showDialog called successfully');
      } catch (e) {
        print('❌ Error showing dialog with screenContext: $e');
      }
    } else {
      print('🔵 Using Get.dialog');
      try {
        Get.dialog(
          TripRatingDialog(
            companyName: _companyName,
            driverName: _driverName,
            onCancel: () {
              print('🔵 onCancel called');
              _navigateToBookingsWithCompletedTab();
            },
            onSubmit: submitReview,
          ),
          barrierDismissible: false,
        );
        print('🔵 Get.dialog called successfully');
      } catch (e) {
        print('❌ Error showing dialog with Get.dialog: $e');
      }
    }
  }

  Future<void> submitReview({
    required double companyRating,
    required String companyComment,
    required double driverRating,
    required String driverComment,
  }) async {
    if (isSubmittingReview.value) return;
    isSubmittingReview.value = true;

    try {
      final List<Map<String, dynamic>> reviews = [
        {"type": "company", "rating": companyRating.toInt(), "comment": companyComment},
        {"type": "driver", "rating": driverRating.toInt(), "comment": driverComment}
      ];

      final int bookingId = _bookingId ?? await _getBookingIdFromTripId(tripId);
      await _trackingRepo.sendReviews(bookingId, reviews);

      // ✅ إغلاق الـ Dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      CustomSnackBar.showSuccess('thanks_for_your_rating');

      // ✅ الانتقال إلى الحجوزات مع تحديث البيانات
      _navigateToBookingsWithCompletedTab();

    } catch (e) {
      debugPrint('❌ فشل إرسال التقييم: $e');
      CustomSnackBar.showError('something_went_wrong');
    } finally {
      isSubmittingReview.value = false;
    }
  }

  // ✅ دالة التنقل المعدلة بالكامل - الحل الصحيح
  void _navigateToBookingsWithCompletedTab() {
    print('🔵 _navigateToBookingsWithCompletedTab STARTED');

    try {
      // ✅ إغلاق الـ Dialog إذا كان مفتوحاً
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // ✅ إغلاق شاشة الخريطة (الرجوع للخلف)
      Get.back();

      // ✅ بعد إغلاق الخريطة، ننتظر قليلاً ثم ننفذ التحديث
      Future.delayed(const Duration(milliseconds: 300), () async {
        try {
          // ✅ التأكد من وجود MainLayoutController
          if (!Get.isRegistered<MainLayoutController>()) {
            print('❌ MainLayoutController not found');
            return;
          }

          // ✅ التأكد من وجود BookingHistoryController
          if (!Get.isRegistered<BookingHistoryController>()) {
            Get.put(BookingHistoryController());
          }

          final mainController = Get.find<MainLayoutController>();
          final bookingController = Get.find<BookingHistoryController>();

          // ✅ 1. مسح الكاش
          final repo = BookingRepository();
          await repo.clearBookingCache();

          // ✅ 2. جلب الحجوزات الجديدة
          await bookingController.fetchBookings();

          // ✅ 3. تغيير الفلتر إلى Completed
          bookingController.changeFilter('Completed');

          // ✅ 4. إعادة تعيين Stack الحجوزات إلى الصفحة الرئيسية
          mainController.bookingStack.assignAll([const BookingHistoryScreen()]);
          mainController.bookingStack.refresh();

          // ✅ 5. التبديل إلى تبويب الحجوزات
          mainController.currentIndex.value = 0;
          mainController.update();

          print('✅ Navigation completed with filter: Completed');
          print('✅ Bookings count: ${bookingController.filteredBookings.length}');

        } catch (e) {
          print('❌ Error during navigation: $e');
        }
      });
    } catch (e) {
      print('❌ Error in _navigateToBookingsWithCompletedTab: $e');
    }
  }

  void _animateBusTo(LatLng newPosition) {
    if (_previousBusLocation == null) {
      busLocation.value = newPosition;
      _previousBusLocation = newPosition;
      return;
    }

    _latAnim = Tween<double>(
      begin: _previousBusLocation!.latitude,
      end: newPosition.latitude,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOut));

    _lngAnim = Tween<double>(
      begin: _previousBusLocation!.longitude,
      end: newPosition.longitude,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOut));

    _animController.stop();
    _animController.forward(from: 0.0);

    _animController.removeListener(_onAnimTick);
    _animController.addListener(_onAnimTick);

    _previousBusLocation = newPosition;
  }

  void _onAnimTick() {
    if (_latAnim != null && _lngAnim != null) {
      busLocation.value = LatLng(_latAnim!.value, _lngAnim!.value);
    }
  }

  void onMapReady() {
    isMapReady.value = true;
    updateCamera();
  }

  void updateCamera() {
    if (polylinePoints.length < 2 || !isMapReady.value) return;
    mapController.fitCamera(CameraFit.coordinates(
      coordinates: polylinePoints,
      padding: const EdgeInsets.all(100),
    ));
  }

  void centerOnBus() {
    if (busLocation.value != null) mapController.move(busLocation.value!, 15.0);
  }

  Future<void> fetchTripDetails() async {
    isLoading.value = true;
    polylinePoints.clear();
    markers.clear();

    try {
      final repo = Get.find<TripRepository>();
      final TripModel trip = await repo.fetchTripDetails(tripId);

      _previousStatus = trip.status;
      tripStatus.value = trip.status;

      _bookingId = await _getBookingIdFromTripId(tripId);
      _companyId = trip.companyId;
      _companyName = trip.companyName;
      _driverId = trip.driverId;
      _driverName = trip.driverName;

      final allStations = await repo.fetchStations();
      final allRestAreas = await repo.fetchRestAreas();

      List<LatLng> waypoints = [];

      var startStation = allStations.firstWhere(
            (s) => s.id == trip.originStation?.id,
        orElse: () => StationModel(id: 0, name: '', latitude: 0.0, longitude: 0.0),
      );
      if ((startStation.latitude ?? 0) != 0.0) {
        waypoints.add(LatLng(startStation.latitude!, startStation.longitude!));
      }

      for (var area in trip.restAreas) {
        var match = allRestAreas.firstWhere(
              (r) => r.id == area.id,
          orElse: () => RestAreaModel(id: -1, name: '', description: '', rating: 0.0, ratingCount: 0, latitude: 0.0, longitude: 0.0),
        );
        if ((match.latitude ?? 0) != 0.0) {
          waypoints.add(LatLng(match.latitude!, match.longitude!));
        }
      }

      var endStation = allStations.firstWhere(
            (s) => s.id == trip.destinationStation?.id,
        orElse: () => StationModel(id: 0, name: '', latitude: 0.0, longitude: 0.0),
      );
      if ((endStation.latitude ?? 0) != 0.0) {
        waypoints.add(LatLng(endStation.latitude!, endStation.longitude!));
      }

      List<Marker> newMarkers = [];
      if (waypoints.isNotEmpty) {
        newMarkers.add(Marker(point: waypoints.first, child: const Icon(Icons.location_on, color: Colors.green, size: 32)));
      }
      for (int i = 1; i < waypoints.length - 1; i++) {
        newMarkers.add(Marker(point: waypoints[i], child: const Icon(Icons.coffee, color: Colors.orange, size: 28)));
      }
      if (waypoints.length >= 2) {
        newMarkers.add(Marker(point: waypoints.last, child: const Icon(Icons.flag, color: Colors.red, size: 32)));
      }

      if (trip.routePolyline != null && trip.routePolyline!.isNotEmpty) {
        debugPrint('🟢 route_polyline موجود، طوله: ${trip.routePolyline!.length} حرف');
        final decoded = _decodePolyline(trip.routePolyline!);
        debugPrint('🟢 تم فك تشفير ${decoded.length} نقطة');
        if (decoded.isNotEmpty) {
          debugPrint('🟢 أول نقطة: ${decoded.first}, آخر نقطة: ${decoded.last}');
        }
        polylinePoints.assignAll(decoded);
      } else {
        debugPrint('🔴 route_polyline فاضي أو null');
        if (waypoints.length >= 2) polylinePoints.assignAll(waypoints);
      }

      markers.assignAll(newMarkers);
      updateCamera();

      if (trip.status.toLowerCase() == 'completed' && !_ratingDialogShown) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _onTripCompleted();
        });
      }
    } catch (e) {
      debugPrint('❌ fetchTripDetails error: $e');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<int> _getBookingIdFromTripId(int tripId) async {
    try {
      final bookingRepo = Get.find<BookingRepository>();
      final bookings = await bookingRepo.fetchBookingHistory();

      final booking = bookings.firstWhere(
            (b) => b.tripId == tripId,
        orElse: () => throw Exception('Booking not found for trip $tripId'),
      );
      return booking.id;
    } catch (e) {
      debugPrint('❌ فشل جلب booking_id: $e');
      return tripId;
    }
  }

  void testCompleteTrip() {
    print('🔵🔵🔵 TEST: Simulating trip completion');
    tripStatus.value = 'completed';
    _onTripCompleted();
    _statusPollingTimer?.cancel();
  }
}