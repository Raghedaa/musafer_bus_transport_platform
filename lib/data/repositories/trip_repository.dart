import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../models/city_model.dart';
import '../models/notification_model.dart';
import '../models/rest_area_model.dart';
import '../models/station_model.dart';
import '../models/trip_model.dart';
import '../providers/trip_provider.dart';
import 'package:get_storage/get_storage.dart';

class TripRepository {
  final TripProvider _tripProvider = TripProvider();
  final Box _popularTripsBox = Hive.box('popular_trips_box');
  final Box _detailsBox = Hive.box('trip_details_box');
  final Box _citiesBox = Hive.box('cities_box');
  final Box _restAreasBox = Hive.box('rest_areas_box');
  final Box _stationsBox = Hive.box('stations_box');


  Future<List<CityModel>> fetchCities() async {
    try {
      final response = await _tripProvider.getCities();
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'] ?? response.data;
        await _citiesBox.put('cities_list', jsonEncode(data));
        return data.map((json) => CityModel.fromJson(json)).toList();
      }
    } catch (e) {
      final cached = _citiesBox.get('cities_list');
      if (cached != null) {
        try {
          final List<dynamic> decoded = jsonDecode(cached);
          return decoded.map((json) => CityModel.fromJson(json)).toList();
        } catch (_) {
          if (cached is List) {
            return cached.map((json) => CityModel.fromJson(json)).toList();
          }
        }
      }
    }
    return [];
  }

  Future<({List<TripModel> data, int lastPage, bool hasMore})> fetchPopularTrips({int page = 1}) async {
    try {
      final response = await _tripProvider.getPopularTrips(page: page);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> rawData = (response.data['data'] as List<dynamic>?) ?? [];

        if (page == 1) {
          await _popularTripsBox.put('popular_list', rawData);
        }

        final List<TripModel> trips = rawData.map((json) => TripModel.fromJson(json)).toList();

        final links = response.data['links'];
        final bool hasMore = links != null && links['next'] != null;

        return (data: trips, lastPage: hasMore ? page + 1 : page, hasMore: hasMore);
      }
    } catch (e) {
      if (page == 1) {
        final cached = _popularTripsBox.get('popular_list');
        if (cached != null && cached is List) {
          final trips = cached
              .map((item) => TripModel.fromJson(Map<String, dynamic>.from(item as Map)))
              .toList();
          return (data: trips, lastPage: 1, hasMore: false);
        }
      }
    }
    return (data: <TripModel>[], lastPage: 1, hasMore: false);
  }
  void _prefetchTripDetailsInBackground(List<int> tripIds) {
    for (var id in tripIds) {
      _tripProvider.getTripDetails(id).then((response) {
        if (response.statusCode == 200 && response.data != null) {
          _detailsBox.put(id, response.data['data']);
        }
      }).catchError((e) {
      });
    }
  }


  Future<List<TripModel>> fetchSearchedTrips({
    required String originId,
    required String destinationId,
    required String date,
    required String time,
    bool forceRefresh = false,
  }) async {
    final cacheKey = 'searched_${originId}_${destinationId}_${date}_$time';

    print("🔍 البحث عن رحلات: $originId → $destinationId, التاريخ: $date, الوقت: $time");

    try {
      final response = await _tripProvider.searchTrips(
        originId: originId,
        destinationId: destinationId,
        date: date,
        time: time,
      );

      print("📡 استجابة API: StatusCode = ${response.statusCode}");

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'] ?? response.data;

        print("📊 عدد الرحلات المستلمة من API: ${data.length}");

        await _popularTripsBox.put(cacheKey, data);
        print("💾 تم تحديث الكاش بنجاح");

        final ids = data.map((e) => e['id'] as int).toList();
        _prefetchTripDetailsInBackground(ids);

        return data.map((json) => TripModel.fromJson(json)).toList();
      }
    } catch (e) {
      print("❌ خطأ في جلب البيانات من API: $e");

      final cached = _popularTripsBox.get(cacheKey);
      if (cached != null) {
        print("💾 تم تحميل ${cached.length} رحلة من الكاش");
        return (cached as List)
            .map((json) => TripModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      }
      rethrow;
    }

    return [];
  }


  Future<TripModel> fetchTripDetails(int tripId) async {
    try {
      final response = await _tripProvider.getTripDetails(tripId);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        await _detailsBox.put(tripId, data);
        return TripModel.fromJson(data);
      }
    } catch (e) {
      final cachedData = _detailsBox.get(tripId);
      if (cachedData != null) {
        Map<String, dynamic> data;

        if (cachedData is Map) {
          data = Map<String, dynamic>.from(cachedData);
        } else if (cachedData is String) {
          data = jsonDecode(cachedData);
        } else {
          rethrow;
        }

        if (data.containsKey('vehicle') && data['vehicle'] != null) {
          print("✅ تم تحميل الرحلة $tripId من الكاش (بيانات كاملة)");
          return TripModel.fromJson(data);
        } else {
          print("⚠️ بيانات الكاش للرحلة $tripId ناقصة (بدون vehicle)، يتم حذفها...");
          await _detailsBox.delete(tripId);
          rethrow;
        }
      }
      rethrow;
    }

    throw Exception("Failed to fetch trip details for ID: $tripId");
  }


  Future<List<RestAreaModel>> fetchRestAreas() async {
    try {
      final response = await _tripProvider.getRestAreas();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        await _restAreasBox.put('list', jsonEncode(data));
        return data.map((e) => RestAreaModel.fromJson(e)).toList();
      }
    } catch (e) {
      final cached = _restAreasBox.get('list');
      if (cached != null) return (jsonDecode(cached) as List).map((e) =>
          RestAreaModel.fromJson(e)).toList();
    }
    return [];
  }


  Future<List<StationModel>> fetchStations() async {
    try {
      final response = await _tripProvider.getStations();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        await _stationsBox.put('list', jsonEncode(data));
        return data.map((e) => StationModel.fromJson(e)).toList();
      }
    } catch (e) {
      final cached = _stationsBox.get('list');
      if (cached != null) return (jsonDecode(cached) as List)
          .map((e) => StationModel.fromJson(e))
          .toList();
    }
    return [];
  }
}