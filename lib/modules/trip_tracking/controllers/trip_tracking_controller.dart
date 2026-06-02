import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../data/models/rest_area_model.dart';
import '../../../data/models/station_model.dart';
import '../../../data/models/trip_model.dart';
import '../../../data/repositories/trip_repository.dart';
import 'dart:math';


class TripTrackingController extends GetxController {
  final int tripId;
  TripTrackingController({required this.tripId});

  var isMapReady = false.obs;
  var polylinePoints = <LatLng>[].obs;
  var markers = <Marker>[].obs;
  var busLocation = Rxn<LatLng>();
  var isLoading = true.obs;
  late MapController mapController;


  StreamSubscription<Position>? positionStream;

  @override
  void onInit() {
    super.onInit();
    polylinePoints.clear();
    markers.clear();
    mapController = MapController();
    fetchTripDetails();
    _startTracking();
  }

  @override
  void onClose() {
    positionStream?.cancel();
    mapController.dispose();
    super.onClose();
  }



  void _startTracking() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      LatLng newPos = LatLng(position.latitude, position.longitude);
      busLocation.value = newPos;
    });
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

  Future<void> fetchTripDetails() async {
    isLoading.value = true;
    polylinePoints.clear();
    markers.clear();
    busLocation.value = null;
    try {
      final repo = Get.find<TripRepository>();
      final TripModel trip = await repo.fetchTripDetails(tripId);
      final allStations = await repo.fetchStations();
      final allRestAreas = await repo.fetchRestAreas();

      List<LatLng> waypoints = [];


      var startStation = allStations.firstWhere(
            (s) => s.id == trip.originStation?.id,
        orElse: () => StationModel(id: 0, name: "", latitude: 0.0, longitude: 0.0),
      );

      if (startStation.latitude != null && startStation.latitude != 0.0) {
        waypoints.add(LatLng(startStation.latitude!, startStation.longitude!));
      }

      for (var area in trip.restAreas) {
        var match = allRestAreas.firstWhere(
              (r) => r.id == area.id,
          orElse: () => RestAreaModel(id: -1, name: "", description: "", rating: 0.0, ratingCount: 0, latitude: 0.0, longitude: 0.0),
        );
        if (match.latitude != null && match.latitude != 0.0) {
          waypoints.add(LatLng(match.latitude!, match.longitude!));
        }
      }

      var endStation = allStations.firstWhere(
            (s) => s.id == trip.destinationStation?.id,
        orElse: () => StationModel(id: 0, name: "", latitude: 0.0, longitude: 0.0),
      );
      if (endStation.latitude != null && endStation.latitude != 0.0) {
        waypoints.add(LatLng(endStation.latitude!, endStation.longitude!));
      }

      if (waypoints.length >= 2) {
        String coordsString = waypoints.map((p) => "${p.longitude},${p.latitude}").join(';');
        final url = "https://router.project-osrm.org/route/v1/driving/$coordsString?overview=full&geometries=geojson";

        final response = await Dio().get(url);
        if (response.statusCode == 200) {
          final List<dynamic> coords = response.data['routes'][0]['geometry']['coordinates'];
          polylinePoints.assignAll(coords.map((c) => LatLng(c[1], c[0])).toList());
        }
      }

      List<Marker> newMarkers = [];

      if (waypoints.isNotEmpty) {
        newMarkers.add(Marker(point: waypoints.first, child: const Icon(Icons.location_on, color: Colors.green)));
      }

      if (waypoints.length > 2) {
        for (int i = 1; i < waypoints.length - 1; i++) {
          newMarkers.add(Marker(point: waypoints[i], child: const Icon(Icons.coffee, color: Colors.orange)));
        }
      }

      if (waypoints.length >= 2) {
        newMarkers.add(Marker(point: waypoints.last, child: const Icon(Icons.flag, color: Colors.red)));
      }

      markers.assignAll(newMarkers);

      updateCamera();
    } catch (e) {
      debugPrint("خطأ في fetchTripDetails: $e");
    } finally {
      isLoading.value = false;
    }
  }
}