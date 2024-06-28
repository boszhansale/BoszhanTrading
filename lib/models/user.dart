import 'package:boszhan_trading/models/store.dart'; // Ensure the correct import path for Store model

class User {
  final int id;
  final String name;
  final String login;
  String? phone;
  String? storeName;
  int? storeId;
  String? storageName;
  String? organizationName;
  String? bank;
  List<Store> stores;

  User({
    required this.id,
    required this.name,
    required this.login,
    this.phone,
    this.storeName,
    this.storeId,
    this.storageName,
    this.organizationName,
    this.bank,
    this.stores = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<Store> userStores = [];
    if (json['stores'] != null) {
      json['stores'].forEach((storeJson) {
        userStores.add(Store.fromJson(storeJson));
      });
    }

    return User(
      id: json['id'],
      name: json['name'],
      login: json['login'],
      phone: json['phone'] ?? '',
      storeName: json['store']?['name'] ?? '',
      storeId: json['store']?['id'] ?? 0,
      storageName: json['storage']?['name'] ?? '',
      organizationName: json['organization']?['name'] ?? '',
      bank: json['bank'] ?? '',
      stores: userStores,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'login': login,
      'phone': phone ?? '',
      'store': {
        'name': storeName ?? '',
        'id': storeId ?? 0,
      },
      'storage': {
        'name': storageName ?? '',
      },
      'organization': {
        'name': organizationName ?? '',
      },
      'bank': bank ?? '',
    };

    if (stores != null) {
      data['stores'] = stores!.map((store) => store.toJson()).toList();
    }

    return data;
  }
}
