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
  });

  factory User.fromJson(Map<String, dynamic> json) {
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
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['login'] = login;
    data['store'] = {};
    data['store']['name'] = storeName;
    data['store']['id'] = storeId;
    data['storage'] = {};
    data['storage']['name'] = storageName;
    data['organization'] = {};
    data['organization']['name'] = organizationName;
    data['bank'] = bank;

    return data;
  }
}
