import 'package:boszhan_trading/models/product.dart';

class ReturnOrderHistoryModel {
  final int id;
  final int orderId;
  final String? storeName;
  final int productsCount;
  final double totalPrice;
  final List<Product> products;
  final String createdAt;
  final String? printUrl;
  final String? checkNumber;

  ReturnOrderHistoryModel({
    required this.id,
    required this.orderId,
    this.storeName,
    required this.productsCount,
    required this.totalPrice,
    required this.products,
    required this.createdAt,
    required this.printUrl,
    required this.checkNumber,
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
      createdAt: json['created_at'] ?? '',
      printUrl: json['ticket_print_url'],
      checkNumber: json['check_number'],
    );
  }
}
