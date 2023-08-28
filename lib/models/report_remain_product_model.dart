class ReportRemainProduct {
  final int id;
  final String? id_1c;
  final String? article;
  final String? name;
  final String measure;
  final double receipt;
  final double sale;
  final double moving;
  final double remains;

  ReportRemainProduct({
    required this.id,
    this.id_1c,
    this.article,
    this.name,
    required this.measure,
    required this.receipt,
    required this.sale,
    required this.moving,
    required this.remains,
  });

  factory ReportRemainProduct.fromJson(Map<String, dynamic> json) {
    return ReportRemainProduct(
      id: json['product_id'],
      id_1c: json['id_1c'].toString(),
      article: json['article'].toString(),
      name: json['name'],
      measure: json['measure'] == 1 ? "шт" : "кг",
      receipt: double.tryParse(json['receipt']) ?? 0,
      sale: double.tryParse(json['sale']) ?? 0,
      moving: double.tryParse(json['moving_from']) ?? 0,
      remains: double.tryParse(json['remains']) ?? 0,
    );
  }
}
