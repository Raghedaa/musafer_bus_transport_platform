import 'dart:convert';
import 'package:hive/hive.dart';
import '../providers/promo_provider.dart';

class PromoRepository {
  final PromoProvider _provider = PromoProvider();

  Future<List<dynamic>> getPromoCodes() async {
    try {
      final response = await _provider.fetchPromoCodes();
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        final box = await Hive.openBox('promo_box'); // فتح آمن
        await box.put('promo_list', data);
        return data;
      }
      return (await Hive.openBox('promo_box')).get('promo_list') ?? [];
    } catch (e) {
      return (await Hive.openBox('promo_box')).get('promo_list') ?? [];
    }
  }



  Future<Map<String, dynamic>?> validatePromoCode(String code, int tripId) async {
    try {
      final res = await _provider.validatePromoCode(code, tripId);

      if (res.statusCode == 200 && res.data != null && res.data['valid'] == true) {
        return Map<String, dynamic>.from(res.data);
      }
      return null;
    } catch (e) {
      print("Error validating promo: $e");
      return null;
    }
  }
}