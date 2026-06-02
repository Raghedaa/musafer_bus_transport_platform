class SeatModel {
  final String label;
  final int rowIndex;
  final int columnIndex;
  final int status;
  final String? gender;

  SeatModel({
    required this.label,
    required this.rowIndex,
    required this.columnIndex,
    required this.status,
    required this.gender,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      label: json['label'] ?? "",
      rowIndex: json['row_index'] ?? 0,
      columnIndex: json['column_index'] ?? 0,
      status: json['status'] ?? 0,
      gender: json['gender'],
    );
  }
}