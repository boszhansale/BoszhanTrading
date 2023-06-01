class ProductReportModel {
  final String name;
  final double remainsStart;
  final double remainsEnd;
  final double receipt;
  final double refund;
  final double refundProducer;
  final double order;
  final double movingFrom;
  final double movingTo;
  final double overage;
  final double totalReceipt;

  ProductReportModel({
    required this.name,
    required this.remainsStart,
    required this.remainsEnd,
    required this.receipt,
    required this.refund,
    required this.refundProducer,
    required this.order,
    required this.movingFrom,
    required this.movingTo,
    required this.overage,
    required this.totalReceipt,
  });

  factory ProductReportModel.fromJson(Map<String, dynamic> json) {
    return ProductReportModel(
      name: json['product_name'],
      remainsStart: double.tryParse(json['remains_start'].toString()) ?? 0,
      remainsEnd: double.tryParse(json['remains_end'].toString()) ?? 0,
      receipt: double.tryParse(json['receipt'].toString()) ?? 0,
      refund: double.tryParse(json['refund'].toString()) ?? 0,
      refundProducer: double.tryParse(json['refund_producer'].toString()) ?? 0,
      order: double.tryParse(json['order'].toString()) ?? 0,
      movingFrom: double.tryParse(json['moving_from'].toString()) ?? 0,
      movingTo: double.tryParse(json['moving_to'].toString()) ?? 0,
      overage: double.tryParse(json['overage'].toString()) ?? 0,
      totalReceipt: double.tryParse(json['total_receipt'].toString()) ?? 0,
    );
  }
}
