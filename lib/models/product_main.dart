class ProductMain {
  final int id;
  final String? id_1c;
  final String? article;
  final String? name;
  final double price;
  final double? discountPrice;
  final String measure;
  final String? barcode;

  ProductMain({
    required this.id,
    this.id_1c,
    this.article,
    this.name,
    required this.price,
    this.discountPrice,
    required this.measure,
    this.barcode,
  });

  factory ProductMain.fromJson(Map<String, dynamic> json) {
    return ProductMain(
      id: json['id'],
      id_1c: json['id_1c'],
      article: json['article'],
      name: json['name'],
      price: double.tryParse(json['price'].toString()) ?? 0,
      discountPrice: double.tryParse(json['discount_price'].toString()) ?? 0,
      measure: json['measure'] == 1 ? "шт" : "кг",
      barcode: json['barcode'],
    );
  }
}
