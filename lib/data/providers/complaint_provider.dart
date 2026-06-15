import 'package:dio/dio.dart' hide Response;
import 'package:dio/src/response.dart';
import 'package:get/get.dart' hide FormData, Response, MultipartFile;
import '../../../../core/services/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';


class ComplaintsProvider {
  final ApiService _api = Get.find<ApiService>();

  Future<Response> sendComplaint({
    required int tripId,
    required int bookingId,
    required int categoryId,
    required String description,
    List<PlatformFile>? files,
  }) async {
    FormData formData = FormData.fromMap({
      'trip_id': tripId,
      'booking_id': bookingId,
      'complaint_category_id': categoryId,
      'description': description,
    });

    if (files != null) {
      for (var file in files) {
        if (file.path != null) {
          formData.files.add(MapEntry(
            'attachments[]',
            await MultipartFile.fromFile(file.path!, filename: file.name),
          ));
        }
      }
    }
    return await _api.post(endPoint: 'passenger/complaints', data: formData);
  }

  Future<Response> getComplaints() async {
    return await _api.get(endPoint: 'passenger/complaints');
  }

  Future<Response> getComplaintDetails(int id) async {
    return await _api.get(endPoint: 'passenger/complaints/$id');
  }

  Future<Response> getCategories() async {
    return await _api.get(endPoint: 'passenger/complaint-categories');
  }
}