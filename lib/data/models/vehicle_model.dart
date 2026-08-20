//
// import 'seat_model.dart';
//
// class VehicleModel {
//   final int id;
//   final dynamic layoutConfig;
//   final List<SeatModel> seats;
//
//   VehicleModel({required this.id, required this.layoutConfig, required this.seats});
//
//   factory VehicleModel.fromJson(Map<String, dynamic> json, List<dynamic> seatMapJson) {
//     final layout = json['layout_config'];
//     final rows = layout['grid']['rows'] as int;
//     final cols = layout['grid']['columns'] as int;
//
//     final staticElements = layout['static_elements'] as List;
//     final aisleElement = staticElements.firstWhere(
//             (e) => e['type'] == "aisle",
//         orElse: () => {'column': -1, 'row_start': 1, 'row_end': rows}
//     );
//
//     final aisle = aisleElement['column'] as int? ?? -1;
//     final rowStart = aisleElement['row_start'] as int? ?? 1;
//     final rowEnd = aisleElement['row_end'] as int? ?? rows;
//
//     List<SeatModel> generatedSeats = [];
//     int seatCounter = 1;
//
//     for (int r = 1; r <= rows; r++) {
//       final bool hasAisle = r >= rowStart && r <= rowEnd && aisle != -1;
//
//       for (int c = 1; c <= cols; c++) {
//         if (hasAisle && c == aisle) continue;
//
//         final seatMapEntry = seatMapJson.firstWhere(
//                 (s) => s['seat_number'] == seatCounter,
//             orElse: () => {'is_booked': false, 'gender': null}
//         );
//
//         generatedSeats.add(SeatModel(
//           label: seatCounter.toString(),
//           rowIndex: r,
//           columnIndex: c,
//           status: (seatMapEntry['is_booked'] == true) ? 3 : 0,
//           gender: seatMapEntry['gender'] != null ? seatMapEntry['gender'].toString() : null,
//         ));
//         seatCounter++;
//       }
//     }
//
//
//     int expectedSeats = 0;
//     for (int r = 1; r <= rows; r++) {
//       final bool hasAisle = r >= rowStart && r <= rowEnd && aisle != -1;
//       expectedSeats += cols - (hasAisle ? 1 : 0);
//     }
//
//     print('Expected seats: $expectedSeats, Generated seats: ${generatedSeats.length}');
//
//     if (generatedSeats.length < expectedSeats) {
//       print('⚠️ Missing seats detected! Adding missing seats...');
//
//       Set<int> existingNumbers = generatedSeats
//           .map((s) => int.tryParse(s.label) ?? 0)
//           .toSet();
//
//       List<SeatModel> fixedSeats = [];
//       int newSeatCounter = 1;
//
//       for (int r = 1; r <= rows; r++) {
//         final bool hasAisle = r >= rowStart && r <= rowEnd && aisle != -1;
//
//         for (int c = 1; c <= cols; c++) {
//           if (hasAisle && c == aisle) continue;
//
//           final existingSeat = generatedSeats.firstWhere(
//                   (s) => s.rowIndex == r && s.columnIndex == c,
//               orElse: () => SeatModel(
//                 label: newSeatCounter.toString(),
//                 rowIndex: r,
//                 columnIndex: c,
//                 status: 0,
//                 gender: null,
//               )
//           );
//
//           final seatMapEntry = seatMapJson.firstWhere(
//                   (s) => s['seat_number'] == newSeatCounter,
//               orElse: () => {'is_booked': false, 'gender': null}
//           );
//
//           fixedSeats.add(SeatModel(
//             label: newSeatCounter.toString(),
//             rowIndex: r,
//             columnIndex: c,
//             status: (seatMapEntry['is_booked'] == true) ? 3 : 0,
//             gender: seatMapEntry['gender'] != null ? seatMapEntry['gender'].toString() : null,
//           ));
//
//           newSeatCounter++;
//         }
//       }
//
//       print('✅ Fixed seats count: ${fixedSeats.length}');
//       generatedSeats = fixedSeats;
//     }
//
//     return VehicleModel(
//       id: json['id'],
//       layoutConfig: layout,
//       seats: generatedSeats,
//     );
//   }
// }



import 'seat_model.dart';

class VehicleModel {
  final int id;
  final dynamic layoutConfig;
  final List<SeatModel> seats;

  VehicleModel({required this.id, required this.layoutConfig, required this.seats});

  factory VehicleModel.fromJson(Map<String, dynamic>? json, List<dynamic>? seatMapJson) {
    // ✅ إذا كانت json null أو فارغة، أرجع نموذج فارغ
    if (json == null || json.isEmpty) {
      return VehicleModel(
        id: 0,
        layoutConfig: {
          'grid': {'rows': 0, 'columns': 0},
          'static_elements': [],
        },
        seats: [],
      );
    }

    // ✅ إذا كانت seatMapJson null، استخدم قائمة فارغة
    final safeSeatMap = seatMapJson ?? [];

    final layout = json['layout_config'];

    // ✅ تحقق من وجود layout
    if (layout == null) {
      return VehicleModel(
        id: json['id'] ?? 0,
        layoutConfig: {
          'grid': {'rows': 0, 'columns': 0},
          'static_elements': [],
        },
        seats: [],
      );
    }

    final rows = layout['grid']?['rows'] as int? ?? 0;
    final cols = layout['grid']?['columns'] as int? ?? 0;

    // ✅ إذا كان عدد الصفوف أو الأعمدة صفر، أرجع نموذج فارغ
    if (rows == 0 || cols == 0) {
      return VehicleModel(
        id: json['id'] ?? 0,
        layoutConfig: layout,
        seats: [],
      );
    }

    final staticElements = layout['static_elements'] as List? ?? [];
    final aisleElement = staticElements.firstWhere(
            (e) => e['type'] == "aisle",
        orElse: () => {'column': -1, 'row_start': 1, 'row_end': rows}
    );

    final aisle = aisleElement['column'] as int? ?? -1;
    final rowStart = aisleElement['row_start'] as int? ?? 1;
    final rowEnd = aisleElement['row_end'] as int? ?? rows;

    List<SeatModel> generatedSeats = [];
    int seatCounter = 1;

    for (int r = 1; r <= rows; r++) {
      final bool hasAisle = r >= rowStart && r <= rowEnd && aisle != -1;

      for (int c = 1; c <= cols; c++) {
        if (hasAisle && c == aisle) continue;

        final seatMapEntry = safeSeatMap.firstWhere(
                (s) => s['seat_number'] == seatCounter,
            orElse: () => {'is_booked': false, 'gender': null}
        );

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

    int expectedSeats = 0;
    for (int r = 1; r <= rows; r++) {
      final bool hasAisle = r >= rowStart && r <= rowEnd && aisle != -1;
      expectedSeats += cols - (hasAisle ? 1 : 0);
    }

    print('Expected seats: $expectedSeats, Generated seats: ${generatedSeats.length}');

    if (generatedSeats.length < expectedSeats) {
      print('⚠️ Missing seats detected! Adding missing seats...');

      List<SeatModel> fixedSeats = [];
      int newSeatCounter = 1;

      for (int r = 1; r <= rows; r++) {
        final bool hasAisle = r >= rowStart && r <= rowEnd && aisle != -1;

        for (int c = 1; c <= cols; c++) {
          if (hasAisle && c == aisle) continue;

          final seatMapEntry = safeSeatMap.firstWhere(
                  (s) => s['seat_number'] == newSeatCounter,
              orElse: () => {'is_booked': false, 'gender': null}
          );

          fixedSeats.add(SeatModel(
            label: newSeatCounter.toString(),
            rowIndex: r,
            columnIndex: c,
            status: (seatMapEntry['is_booked'] == true) ? 3 : 0,
            gender: seatMapEntry['gender'] != null ? seatMapEntry['gender'].toString() : null,
          ));

          newSeatCounter++;
        }
      }

      print('✅ Fixed seats count: ${fixedSeats.length}');
      generatedSeats = fixedSeats;
    }

    return VehicleModel(
      id: json['id'] ?? 0,
      layoutConfig: layout,
      seats: generatedSeats,
    );
  }
}