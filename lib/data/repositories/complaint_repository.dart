import 'dart:convert';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:hive/hive.dart';
import '../models/complaint_category_model.dart';
import '../models/complaint_model.dart';
import '../providers/complaint_provider.dart';import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import 'package:file_picker/file_picker.dart';



class ComplaintsRepository {
  final ComplaintsProvider _provider = ComplaintsProvider();

  static const _boxName = 'complaints_box';
  static const _categoriesKey = 'complaint_categories';
  static const _complaintsKey = 'my_complaints';

  Box get _box => Hive.box(_boxName);

  Future<bool> sendComplaint({
    required int tripId,
    required int bookingId,
    required int categoryId,
    required String description,
    List<PlatformFile>? files,
  }) async {
    try {
      final res = await _provider.sendComplaint(
        tripId: tripId,
        bookingId: bookingId,
        categoryId: categoryId,
        description: description,
        files: files,
      );
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<List<ComplaintModel>> getComplaints() async {
    try {
      final res = await _provider.getComplaints();
      final List data = res.data['data'] ?? [];
      final list = data.map((e) => ComplaintModel.fromJson(e)).toList();
      _box.put(_complaintsKey, jsonEncode(list.map((e) => e.toJson()).toList()));
      return list;
    } catch (_) {
      return _cachedComplaints();
    }
  }

  List<ComplaintModel> _cachedComplaints() {
    final raw = _box.get(_complaintsKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => ComplaintModel.fromJson(e))
        .toList();
  }

  Future<List<ComplaintCategoryModel>> getCategories() async {
    try {
      final res = await _provider.getCategories();
      final List data = res.data['data'] ?? [];
      final list = data.map((e) => ComplaintCategoryModel.fromJson(e)).toList();
      _box.put(_categoriesKey, jsonEncode(list.map((e) => e.toJson()).toList()));
      return list;
    } catch (_) {
      return _cachedCategories();
    }
  }

  List<ComplaintCategoryModel> _cachedCategories() {
    final raw = _box.get(_categoriesKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => ComplaintCategoryModel.fromJson(e))
        .toList();
  }
}