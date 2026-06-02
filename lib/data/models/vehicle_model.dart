import 'seat_model.dart';

class VehicleModel {
  final int id;
  final dynamic layoutConfig;
  final List<SeatModel> seats;

  VehicleModel({required this.id, required this.layoutConfig, required this.seats});

  factory VehicleModel.fromJson(Map<String, dynamic> json, List<dynamic> seatMapJson) {
    final layout = json['layout_config'];
    final rows = layout['grid']['rows'] as int;
    final cols = layout['grid']['columns'] as int;

    final aisle = (layout['static_elements'] as List)
        .firstWhere((e) => e['type'] == "aisle", orElse: () => {'column': -1})['column'];

    List<SeatModel> generatedSeats = [];
    int seatCounter = 1;

    for (int r = 1; r <= rows; r++) {
      for (int c = 1; c <= cols; c++) {
        if (c == aisle) continue;

        // البحث عن حالة المقعد في seat_map القادم من الـ API
        final seatMapEntry = seatMapJson.firstWhere(
                (s) => s['seat_number'] == seatCounter,
            orElse: () => {'is_booked': false});

        generatedSeats.add(SeatModel(
          label: seatCounter.toString(),
          rowIndex: r,
          columnIndex: c,
          status: (seatMapEntry['is_booked'] == true) ? 3 : 0,

          gender: seatMapEntry['gender'] != null ? seatMapEntry['gender'].toString() : null,
        ));
        seatCounter++;
      }
    }

    return VehicleModel(
      id: json['id'],
      layoutConfig: layout,
      seats: generatedSeats,
    );
  }
}