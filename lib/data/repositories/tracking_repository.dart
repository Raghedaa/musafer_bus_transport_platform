import '../providers/tracking_provider.dart';

class TrackingRepository {
  final TrackingProvider _provider = TrackingProvider();


  Future<void> sendReviews(int bookingId, List<Map<String, dynamic>> reviews) async {
    final response = await _provider.submitReviewBatch({
      "booking_id": bookingId,
      "reviews": reviews,
    });

    if (response.statusCode != 200 && response.statusCode != 201) {
      final message = response.data['message'] ?? 'Failed to submit reviews';
      throw Exception(message);
    }
  }
}