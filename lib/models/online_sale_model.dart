import 'package:boszhan_trading/models/product.dart';
import 'package:intl/intl.dart';

class OnlineSaleOrderModel {
  final int id;
  final String? discountPhone;
  final int productsCount;
  final double totalPrice;
  final List<Product> products;
  final String? createdAt;
  final String? discountCashback;

  OnlineSaleOrderModel({
    required this.id,
    required this.discountPhone,
    required this.productsCount,
    required this.totalPrice,
    required this.products,
    required this.createdAt,
    required this.discountCashback,
  });

  factory OnlineSaleOrderModel.fromJson(Map<String, dynamic> json) {
    return OnlineSaleOrderModel(
      id: json['id'],
      discountPhone: json['discount_phone'],
      productsCount: json['products'].length ?? 0,
      totalPrice: double.tryParse(json['total_price'] ?? '0') ?? 0,
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e))
          .toList(),
      createdAt: DateFormat('yyyy-MM-dd HH:mm')
          .format(DateTime.tryParse(json['created_at']) ?? DateTime.now()),
      discountCashback: (json['discount_cashback'] ?? 0).toString(),
    );
  }
}
