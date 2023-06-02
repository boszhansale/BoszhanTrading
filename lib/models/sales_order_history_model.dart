import 'package:boszhan_trading/models/product.dart';
import 'package:intl/intl.dart';

class SalesOrderHistoryModel {
  final int id;
  final String? storeName;
  final int productsCount;
  final double totalPrice;
  final List<Product> products;
  final String createdAt;
  final String? printUrl;
  final String? checkNumber;

  SalesOrderHistoryModel({
    required this.id,
    this.storeName,
    required this.productsCount,
    required this.totalPrice,
    required this.products,
    required this.createdAt,
    required this.printUrl,
    required this.checkNumber,
  });

  factory SalesOrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return SalesOrderHistoryModel(
      id: json['id'],
      storeName: json['store']['name'],
      productsCount: json['products'].length ?? 0,
      totalPrice: double.tryParse(json['total_price'] ?? '0') ?? 0,
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e))
          .toList(),
      createdAt: DateFormat('yyyy-MM-dd HH:mm')
          .format(DateTime.tryParse(json['created_at']) ?? DateTime.now()),
      printUrl: json['webkassa_check'] != null
          ? json['webkassa_check']['ticket_print_url']
          : null,
      checkNumber: json['webkassa_check'] != null
          ? json['webkassa_check']['check_number']
          : null,
    );
  }
}
