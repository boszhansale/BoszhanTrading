class Store {
  final int id;
  String? name;
  int? storeId;

  Store({
    required this.id,
    this.name,
    this.storeId,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['store']?['name'] ?? '',
      storeId: json['store']?['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['store']['id'] = storeId;

    return data;
  }
}
