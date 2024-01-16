import 'package:boszhan_trading/models/product.dart';

class SalesOrderHistoryModel {
  final int id;
  final String? storeName;
  final int productsCount;
  final double totalPrice;
  final List<Product> products;
  final String createdAt;
  final String? printUrl;
  final String? checkNumber;
  final String? counteragentName;
  final double? givePrice;
  final List<dynamic> payments;

  SalesOrderHistoryModel({
    required this.id,
    this.storeName,
    required this.productsCount,
    required this.totalPrice,
    required this.products,
    required this.createdAt,
    required this.printUrl,
    required this.checkNumber,
    required this.counteragentName,
    this.givePrice,
    required this.payments,
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
      createdAt: json['created_at'] ?? '',
      printUrl: json['webkassa_check'] != null
          ? json['webkassa_check']['ticket_print_url']
          : null,
      checkNumber: json['webkassa_check'] != null
          ? json['webkassa_check']['check_number']
          : null,
      counteragentName: json['counteragent_id'] == null
          ? 'Физ лицо'
          : json['counteragent']['name'],
      givePrice: double.tryParse(json['give_price']) ?? 0,
      payments: json['payments'] ?? [],
    );
  }
}
