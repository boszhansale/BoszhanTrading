class Product {
  final int id;
  final String? id_1c;
  final String? article;
  final String? name;
  final String? allPrice;
  final double count;
  final double price;
  final String measure;
  final String? returnReasonTitle;

  Product({
    required this.id,
    this.id_1c,
    this.article,
    this.name,
    this.allPrice,
    required this.count,
    required this.price,
    required this.measure,
    this.returnReasonTitle,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product']['id'],
      id_1c: json['product']['id_1c'],
      article: json['product']['article'],
      name: json['product']['name'],
      allPrice: json['all_price'],
      count: double.tryParse(json['count']) ?? 0,
      price: double.tryParse(json['price']) ?? 0,
      measure: json['measure'] == 1 ? "шт" : "кг",
      returnReasonTitle:
          json['reason_refund'] != null ? json['reason_refund']['title'] : null,
    );
  }
}
