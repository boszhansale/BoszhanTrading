class ZReportModel {
  final int id;
  final String createdAt;
  final String? kassir;
  final String? url;

  ZReportModel({
    required this.id,
    required this.createdAt,
    this.kassir,
    this.url,
  });

  factory ZReportModel.fromJson(Map<String, dynamic> json) {
    return ZReportModel(
      id: json['id'],
      createdAt: json['created_at'] ?? '',
      kassir: json['body']['CashierName'],
      url: json['url'],
    );
  }
}
