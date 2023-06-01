class ReportOnlineSaleProduct {
  final int id;
  final String? id_1c;
  final String? article;
  final String? name;
  final String measure;
  final double receipt;
  final double sale;
  final double moving;
  final double remains;

  ReportOnlineSaleProduct({
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

  factory ReportOnlineSaleProduct.fromJson(Map<String, dynamic> json) {
    return ReportOnlineSaleProduct(
      id: json['product_id'],
      id_1c: json['id_1c'],
      article: json['article'],
      name: json['name'],
      measure: json['measure'] == 1 ? "шт" : "кг",
      receipt: double.tryParse(json['receipt']) ?? 0,
      sale: double.tryParse(json['sale']) ?? 0,
      moving: double.tryParse(json['moving']) ?? 0,
      remains: double.tryParse(json['remains']) ?? 0,
    );
  }
}
