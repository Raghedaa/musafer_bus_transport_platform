import 'package:hive/hive.dart';
import '../providers/profile_provider.dart';

class ProfileRepository {
  final ProfileProvider _provider = ProfileProvider();
  final Box _box = Hive.box('user_box');

  Future<dynamic> getProfile() async {
    try {
      final response = await _provider.getProfile();
      if (response.statusCode == 200) {
        _box.put('profile_data', response.data['data']);
        return response.data['data'];
      }
    } catch (e) {
      return _box.get('profile_data');
    }
  }

  Future<Map<String, dynamic>?> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _provider.updateProfile(data);

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['data'] != null) {
          final updatedUser = responseData['data'];
          _box.put('user_data', updatedUser);
          _box.put('profile_data', updatedUser);
          return Map<String, dynamic>.from(updatedUser);
        }
      }
      return null;
    } catch (e) {
      print("Error in Repository: $e");
      return null;
    }
  }

  // أضف هذه الدالة هنا لمعالجة الشحن وتحديث الـ Hive داخلياً
  Future<Map<String, dynamic>?> topUpWallet(String currency, String amount) async {
    try {
      final response = await _provider.topUpWallet({
        "currency": currency,
        "amount": amount,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        if (responseData['data'] != null) {
          return Map<String, dynamic>.from(responseData['data']);
        }
      }
      return null;
    } catch (e) {
      print("Error in Repository topUpWallet: $e");
      return null;
    }
  }
}