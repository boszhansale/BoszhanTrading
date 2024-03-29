import 'package:boszhan_trading/models/product.dart';

class MovingOrderHistoryModel {
  final int id;
  final String? storeName;
  final int productsCount;
  final double totalPrice;
  final List<Product> products;
  final String createdAt;
  final int operation;

  MovingOrderHistoryModel({
    required this.id,
    this.storeName,
    required this.productsCount,
    required this.totalPrice,
    required this.products,
    required this.createdAt,
    required this.operation,
  });

  factory MovingOrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return MovingOrderHistoryModel(
      id: json['id'],
      storeName: json['store'] != null ? json['store']['name'] ?? '' : '',
      productsCount: json['products'].length ?? 0,
      totalPrice: double.tryParse(json['total_price'] ?? '0') ?? 0,
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e))
          .toList(),
      createdAt: json['created_at'] ?? '',
      operation: json['operation'],
    );
  }
}
