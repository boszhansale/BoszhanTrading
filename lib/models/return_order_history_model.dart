import 'package:boszhan_trading/models/product.dart';
import 'package:intl/intl.dart';

class ReturnOrderHistoryModel {
  final int id;
  final int orderId;
  final String? storeName;
  final int productsCount;
  final double totalPrice;
  final List<Product> products;
  final String createdAt;

  ReturnOrderHistoryModel({
    required this.id,
    required this.orderId,
    this.storeName,
    required this.productsCount,
    required this.totalPrice,
    required this.products,
    required this.createdAt,
  });

  factory ReturnOrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return ReturnOrderHistoryModel(
      id: json['id'],
      orderId: json['order_id'],
      storeName: json['store'] != null ? json['store']['name'] ?? '' : '',
      productsCount: json['products'].length ?? 0,
      totalPrice: double.tryParse(json['total_price'] ?? '0') ?? 0,
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e))
          .toList(),
      createdAt: DateFormat('yyyy-MM-dd HH:mm')
          .format(DateTime.tryParse(json['created_at']) ?? DateTime.now()),
    );
  }
}
