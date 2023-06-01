class InventoryProduct {
  final int id;
  final String? id_1c;
  final String? article;
  final String? name;
  final double count;
  final double receipt;
  final double sale;
  final double moving;
  final double remains;
  // final double price;
  final String measure;
  final double shortage;
  final double shortagePrice;

  InventoryProduct({
    required this.id,
    this.id_1c,
    this.article,
    this.name,
    required this.count,
    required this.receipt,
    required this.sale,
    required this.moving,
    required this.remains,
    // required this.price,
    required this.measure,
    required this.shortage,
    required this.shortagePrice,
  });

  factory InventoryProduct.fromJson(Map<String, dynamic> json) {
    return InventoryProduct(
      id: json['product']['id'],
      id_1c: json['product']['id_1c'],
      article: json['product']['article'],
      name: json['product']['name'],
      count: double.tryParse(json['count']) ?? 0,
      receipt: double.tryParse(json['receipt']) ?? 0,
      sale: double.tryParse(json['sale']) ?? 0,
      moving: double.tryParse(json['moving']) ?? 0,
      remains: double.tryParse(json['remains']) ?? 0,
      // price: double.tryParse(json['product']['price']) ?? 0,
      measure: json['product']['measure'] == 1 ? "шт" : "кг",
      shortage: double.tryParse(json['shortage']) ?? 0,
      shortagePrice: double.tryParse(json['shortage_price']) ?? 0,
    );
  }
}
