class InventoryProduct {
  final int id;
  // final String? id_1c;
  // final String? article;
  // final String? name;
  final double count;
  final double receipt;
  final double sale;
  final double moving;
  final double remains;
  // final double price;
  // final String measure;

  InventoryProduct({
    required this.id,
    // this.id_1c,
    // this.article,
    // this.name,
    required this.count,
    required this.receipt,
    required this.sale,
    required this.moving,
    required this.remains,
    // required this.price,
    // required this.measure,
  });

  factory InventoryProduct.fromJson(Map<String, dynamic> json) {
    return InventoryProduct(
      id: json['product_id'],
      // id_1c: json['id_1c'],
      // article: json['article'],
      // name: json['name'],
      count: double.tryParse(json['count']) ?? 0,
      receipt: double.tryParse(json['receipt']) ?? 0,
      sale: double.tryParse(json['sale']) ?? 0,
      moving: double.tryParse(json['moving']) ?? 0,
      remains: double.tryParse(json['remains']) ?? 0,
      // price: double.tryParse(json['price']) ?? 0,
      // measure: json['measure'] == 1 ? "шт" : "кг",
    );
  }
}
