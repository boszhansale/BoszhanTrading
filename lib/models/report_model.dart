class ReportModel {
  String? taxPayerName;
  String? taxPayerIN;
  bool? taxPayerVAT;
  String? taxPayerVATSeria;
  String? taxPayerVATNumber;
  int? reportNumber;
  String? cashboxSN;
  int? cashboxIN;
  String? cashboxRN;
  String? startOn;
  String? closeOn;
  String? reportOn;
  String? cashierCode;
  String? shiftNumber;
  int? documentCount;
  double? putMoneySum;
  double? takeMoneySum;
  double? controlSum;
  bool? offlineMode;
  bool? cashboxOfflineMode;
  double? sumInCashbox;
  Sell? sell;
  Sell? buy;
  Sell? returnSell;
  Sell? returnBuy;
  EndNonNullable? endNonNullable;
  EndNonNullable? startNonNullable;
  Ofd? ofd;

  ReportModel(
      {this.taxPayerName,
      this.taxPayerIN,
      this.taxPayerVAT,
      this.taxPayerVATSeria,
      this.taxPayerVATNumber,
      this.reportNumber,
      this.cashboxSN,
      this.cashboxIN,
      this.cashboxRN,
      this.startOn,
      this.closeOn,
      this.reportOn,
      this.cashierCode,
      this.shiftNumber,
      this.documentCount,
      this.putMoneySum,
      this.takeMoneySum,
      this.controlSum,
      this.offlineMode,
      this.cashboxOfflineMode,
      this.sumInCashbox,
      this.sell,
      this.buy,
      this.returnSell,
      this.returnBuy,
      this.endNonNullable,
      this.startNonNullable,
      this.ofd});

  ReportModel.fromJson(Map<String, dynamic> json) {
    taxPayerName = json['TaxPayerName'];
    taxPayerIN = json['TaxPayerIN'];
    taxPayerVAT = json['TaxPayerVAT'];
    taxPayerVATSeria = json['TaxPayerVATSeria'];
    taxPayerVATNumber = json['TaxPayerVATNumber'];
    reportNumber = json['ReportNumber'];
    cashboxSN = json['CashboxSN'];
    cashboxIN = json['CashboxIN'];
    cashboxRN = json['CashboxRN'];
    startOn = json['StartOn'];
    closeOn = json['CloseOn'];
    reportOn = json['ReportOn'];
    cashierCode = json['CashierCode'].toString();
    shiftNumber = json['ShiftNumber'].toString();
    documentCount = json['DocumentCount'];
    putMoneySum = double.parse(json['PutMoneySum'].toString());
    takeMoneySum = double.parse(json['TakeMoneySum'].toString());
    controlSum = double.parse(json['ControlSum'].toString());
    offlineMode = json['OfflineMode'];
    cashboxOfflineMode = json['CashboxOfflineMode'];
    sumInCashbox = double.parse(json['SumInCashbox'].toString());
    sell = json['Sell'] != null ? new Sell.fromJson(json['Sell']) : null;
    buy = json['Buy'] != null ? new Sell.fromJson(json['Buy']) : null;
    returnSell = json['ReturnSell'] != null
        ? new Sell.fromJson(json['ReturnSell'])
        : null;
    returnBuy =
        json['ReturnBuy'] != null ? new Sell.fromJson(json['ReturnBuy']) : null;
    endNonNullable = json['EndNonNullable'] != null
        ? new EndNonNullable.fromJson(json['EndNonNullable'])
        : null;
    startNonNullable = json['StartNonNullable'] != null
        ? new EndNonNullable.fromJson(json['StartNonNullable'])
        : null;
    ofd = json['Ofd'] != null ? new Ofd.fromJson(json['Ofd']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TaxPayerName'] = this.taxPayerName;
    data['TaxPayerIN'] = this.taxPayerIN;
    data['TaxPayerVAT'] = this.taxPayerVAT;
    data['TaxPayerVATSeria'] = this.taxPayerVATSeria;
    data['TaxPayerVATNumber'] = this.taxPayerVATNumber;
    data['ReportNumber'] = this.reportNumber;
    data['CashboxSN'] = this.cashboxSN;
    data['CashboxIN'] = this.cashboxIN;
    data['CashboxRN'] = this.cashboxRN;
    data['StartOn'] = this.startOn;
    data['CloseOn'] = this.closeOn;
    data['ReportOn'] = this.reportOn;
    data['CashierCode'] = this.cashierCode;
    data['ShiftNumber'] = this.shiftNumber;
    data['DocumentCount'] = this.documentCount;
    data['PutMoneySum'] = this.putMoneySum;
    data['TakeMoneySum'] = this.takeMoneySum;
    data['ControlSum'] = this.controlSum;
    data['OfflineMode'] = this.offlineMode;
    data['CashboxOfflineMode'] = this.cashboxOfflineMode;
    data['SumInCashbox'] = this.sumInCashbox;
    if (this.sell != null) {
      data['Sell'] = this.sell!.toJson();
    }
    if (this.buy != null) {
      data['Buy'] = this.buy!.toJson();
    }
    if (this.returnSell != null) {
      data['ReturnSell'] = this.returnSell!.toJson();
    }
    if (this.returnBuy != null) {
      data['ReturnBuy'] = this.returnBuy!.toJson();
    }
    if (this.endNonNullable != null) {
      data['EndNonNullable'] = this.endNonNullable!.toJson();
    }
    if (this.startNonNullable != null) {
      data['StartNonNullable'] = this.startNonNullable!.toJson();
    }
    if (this.ofd != null) {
      data['Ofd'] = this.ofd!.toJson();
    }
    return data;
  }
}

class Sell {
  List<Null>? paymentsByTypesApiModel;
  int? discount;
  double? markup;
  double? taken;
  double? change;
  int? count;
  int? totalCount;
  double? vAT;

  Sell(
      {this.paymentsByTypesApiModel,
      this.discount,
      this.markup,
      this.taken,
      this.change,
      this.count,
      this.totalCount,
      this.vAT});

  Sell.fromJson(Map<String, dynamic> json) {
    if (json['PaymentsByTypesApiModel'] != null) {
      paymentsByTypesApiModel = <Null>[];
      json['PaymentsByTypesApiModel'].forEach((v) {
        // paymentsByTypesApiModel!.add(new Null.fromJson(v));
      });
    }
    discount = json['Discount'];
    markup = json['Markup'];
    taken = json['Taken'];
    change = json['Change'];
    count = json['Count'];
    totalCount = json['TotalCount'];
    vAT = json['VAT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.paymentsByTypesApiModel != null) {
      // data['PaymentsByTypesApiModel'] =
      // this.paymentsByTypesApiModel!.map((v) => v.toJson()).toList();
    }
    data['Discount'] = this.discount;
    data['Markup'] = this.markup;
    data['Taken'] = this.taken;
    data['Change'] = this.change;
    data['Count'] = this.count;
    data['TotalCount'] = this.totalCount;
    data['VAT'] = this.vAT;
    return data;
  }
}

class EndNonNullable {
  double? sell;
  double? buy;
  double? returnSell;
  double? returnBuy;

  EndNonNullable({this.sell, this.buy, this.returnSell, this.returnBuy});

  EndNonNullable.fromJson(Map<String, dynamic> json) {
    sell = json['Sell'];
    buy = json['Buy'];
    returnSell = json['ReturnSell'];
    returnBuy = json['ReturnBuy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Sell'] = this.sell;
    data['Buy'] = this.buy;
    data['ReturnSell'] = this.returnSell;
    data['ReturnBuy'] = this.returnBuy;
    return data;
  }
}

class Ofd {
  String? name;
  String? host;
  int? code;

  Ofd({this.name, this.host, this.code});

  Ofd.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    host = json['Host'];
    code = json['Code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Host'] = this.host;
    data['Code'] = this.code;
    return data;
  }
}
