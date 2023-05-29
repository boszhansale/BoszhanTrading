import 'package:boszhan_trading/models/inventory_product.dart';
import 'package:intl/intl.dart';

class InventoryOrderHistoryModel {
  final int id;
  final String? storeName;
  final int productsCount;
  final List<InventoryProduct> products;
  final String createdAt;

  InventoryOrderHistoryModel({
    required this.id,
    this.storeName,
    required this.productsCount,
    required this.products,
    required this.createdAt,
  });

  factory InventoryOrderHistoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryOrderHistoryModel(
      id: json['id'],
      storeName: json['store'] != null ? json['store']['name'] ?? '' : '',
      productsCount: json['products'].length ?? 0,
      products: (json['products'] as List<dynamic>)
          .map((e) => InventoryProduct.fromJson(e))
          .toList(),
      createdAt: DateFormat('yyyy-MM-dd HH:mm')
          .format(DateTime.tryParse(json['created_at']) ?? DateTime.now()),
    );
  }
}
