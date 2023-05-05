import 'package:boszhan_trading/models/product.dart';

class WriteOffOrderHistoryModel {
  final int id;
  final String? storeName;
  final int productsCount;
  final double totalPrice;
  final List<Product> products;

  WriteOffOrderHistoryModel({
    required this.id,
    this.storeName,
    required this.productsCount,
    required this.totalPrice,
    required this.products,
  });

  factory WriteOffOrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return WriteOffOrderHistoryModel(
        id: json['id'],
        storeName: json['store']['name'],
        productsCount: json['products'].length ?? 0,
        totalPrice: double.tryParse(json['total_price'] ?? '0') ?? 0,
        products: (json['products'] as List<dynamic>)
            .map((e) => Product.fromJson(e))
            .toList());
  }
}
