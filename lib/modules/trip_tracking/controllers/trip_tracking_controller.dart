import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:pusher_client_socket/pusher_client_socket.dart';
import 'package:pusher_client_socket/channels/private_channel.dart';

import '../../../data/models/rest_area_model.dart';
import '../../../data/models/station_model.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/repositories/trip_repository.dart';


class TripTrackingController extends GetxController with GetTickerProviderStateMixin {
  final int tripId;
  TripTrackingController({required this.tripId});

  var isMapReady = false.obs;
  var isLoading = true.obs;
  var polylinePoints = <LatLng>[].obs;
  var markers = <Marker>[].obs;
  var busLocation = Rxn<LatLng>();
  var myLocation = Rxn<LatLng>();

  late MapController mapController;
  late AnimationController _animController;

  Animation<double>? _latAnim;
  Animation<double>? _lngAnim;
  LatLng? _previousBusLocation;

  PusherClient? _pusher;
  PrivateChannel? _channel;
  bool _isConnected = false;


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
    fetchTripDetails().then((_) => _connectWebSocket());

  }


  @override
  void onClose() {
    _animController.dispose();
    _disconnectWebSocket();
    mapController.dispose();
    super.onClose();
  }



  void _connectWebSocket() {
    try {
      final String token = GetStorage().read('token') ?? '';
      if (token.isEmpty) return;

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

      _pusher!.connect();

      final channel = _pusher!.subscribe('private-trip.$tripId.tracking');

      if (channel is PrivateChannel) {
        _channel = channel;

        _channel!.bind('Modules\\Operations\\Events\\TripLocationUpdated', (dynamic event) {
          debugPrint('📡 [الحدث الأساسي] تم الاستلام: $event');
          _handleLocationEvent(event);
        });

        _channel!.bind('TripLocationUpdated', (dynamic event) {
          debugPrint('📡 [حدث بديل] تم الاستلام: $event');
          _handleLocationEvent(event);
        });

        debugPrint('✅ تم الاشتراك والربط بنجاح');
      }
    } catch (e) {
      debugPrint('❌ WebSocket init failed: $e');
    }
  }


  void _disconnectWebSocket() {
    try {
      _channel?.unbind('Modules\\Operations\\Events\\TripLocationUpdated');
      _pusher?.disconnect();
      _pusher = null;
      _channel = null;
      debugPrint('🔌 WebSocket disconnected');
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

      debugPrint('🚌 تحديث الموقع من الـ Socket: lat=$lat, lng=$lng');

      _animateBusTo(LatLng(lat, lng));

    } catch (e) {
      debugPrint('❌ خطأ في معالجة بيانات الـ Socket: $e');
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

    // ✅ استخدام listener واحد فقط بدل إضافة جديد كل مرة
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
    busLocation.value = null;

    try {
      final repo = Get.find<TripRepository>();
      final TripModel trip = await repo.fetchTripDetails(tripId);

      if (trip.currentLat != null && trip.currentLng != null) {
        busLocation.value = LatLng(trip.currentLat!, trip.currentLng!);
        _previousBusLocation = busLocation.value;
        debugPrint('🚌 Initial bus location: ${trip.currentLat}, ${trip.currentLng}');
      }

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
          orElse: () => RestAreaModel(
            id: -1, name: '', description: '',
            rating: 0.0, ratingCount: 0,
            latitude: 0.0, longitude: 0.0,
          ),
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

      if (waypoints.length >= 2) {
        final coordsString =
        waypoints.map((p) => '${p.longitude},${p.latitude}').join(';');
        final url =
            'https://router.project-osrm.org/route/v1/driving/$coordsString?overview=full&geometries=geojson';
        final response = await Dio().get(url);
        if (response.statusCode == 200) {
          final List<dynamic> coords =
          response.data['routes'][0]['geometry']['coordinates'];
          polylinePoints.assignAll(
            coords.map((c) => LatLng(c[1] as double, c[0] as double)),
          );
        }
      }

      List<Marker> newMarkers = [];
      if (waypoints.isNotEmpty) {
        newMarkers.add(Marker(
          point: waypoints.first,
          child: const Icon(Icons.location_on, color: Colors.green, size: 32),
        ));
      }
      for (int i = 1; i < waypoints.length - 1; i++) {
        newMarkers.add(Marker(
          point: waypoints[i],
          child: const Icon(Icons.coffee, color: Colors.orange, size: 28),
        ));
      }
      if (waypoints.length >= 2) {
        newMarkers.add(Marker(
          point: waypoints.last,
          child: const Icon(Icons.flag, color: Colors.red, size: 32),
        ));
      }

      markers.assignAll(newMarkers);
      updateCamera();
    } catch (e) {
      debugPrint('❌ fetchTripDetails error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}