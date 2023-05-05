class Counteragent {
  final int id;
  final String name;
  final int priceTypeId;
  final bool enabled;

  Counteragent({
    required this.id,
    required this.name,
    required this.priceTypeId,
    required this.enabled,
  });

  factory Counteragent.fromJson(Map<String, dynamic> json) {
    return Counteragent(
      id: json['id'],
      name: json['name'],
      priceTypeId: json['price_type_id'],
      enabled: json['enabled'] == 1 ? true : false,
    );
  }
}
