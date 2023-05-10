import 'package:boszhan_trading/models/product.dart';

class ReturnProducerOrderHistoryModel {
  final int id;
  final String? storeName;
  final int productsCount;
  final double totalPrice;
  final List<Product> products;

  ReturnProducerOrderHistoryModel({
    required this.id,
    this.storeName,
    required this.productsCount,
    required this.totalPrice,
    required this.products,
  });

  factory ReturnProducerOrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return ReturnProducerOrderHistoryModel(
        id: json['id'],
        storeName: json['store'] != null ? json['store']['name'] ?? '' : '',
        productsCount: json['products'].length ?? 0,
        totalPrice: double.tryParse(json['total_price'] ?? '0') ?? 0,
        products: (json['products'] as List<dynamic>)
            .map((e) => Product.fromJson(e))
            .toList());
  }
}
