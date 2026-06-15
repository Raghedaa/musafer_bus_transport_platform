class ComplaintCategoryModel {
  final int id;
  final String nameAr;
  final String nameEn;
  final String iconUrl;
  final bool isActive;

  ComplaintCategoryModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.iconUrl,
    required this.isActive,
  });

  factory ComplaintCategoryModel.fromJson(Map<String, dynamic> json) {
    return ComplaintCategoryModel(
      id: json['id'],
      nameAr: json['name_ar'] ?? '',
      nameEn: json['name_en'] ?? '',
      iconUrl: json['icon_url'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name_ar': nameAr,
    'name_en': nameEn,
    'icon_url': iconUrl,
    'is_active': isActive,
  };
}