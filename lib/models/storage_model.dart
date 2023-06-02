class Storage {
  final int id;
  final String name;
  final bool enabled;

  Storage({
    required this.id,
    required this.name,
    required this.enabled,
  });

  factory Storage.fromJson(Map<String, dynamic> json) {
    return Storage(
      id: json['id'],
      name: json['name'],
      enabled: json['enabled'] == 1 ? true : false,
    );
  }
}
