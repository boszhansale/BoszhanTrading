import 'dart:convert';

import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;

class MainApiService {
  final String baseUrl = 'https://backshop.boszhan.kz/api';

  // TODO: Brands, Categories, Products

  Future<dynamic> getBrands() async {
    final response = await http.get(
      Uri.parse('$baseUrl/brand'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> getCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/category'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> getProducts(bool remainder) async {
    final response = await http.get(
      Uri.parse('$baseUrl/product?remainder=$remainder'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> searchProductByBarcode(String barcode) async {
    final response = await http.get(
      Uri.parse('$baseUrl/product?search=$barcode'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Sales

  Future<Map<String, dynamic>> createSalesOrder(int onlineSale, int paymentType,
      List<dynamic> products, int counteragentId, String phone) async {
    Map<String, dynamic> body = {
      "online_sale": onlineSale,
      "payment_type": paymentType,
      "products": products,
    };

    if (counteragentId != 0) {
      body['counteragent_id'] = counteragentId;
    }

    if (phone != '') {
      body['phone'] = phone;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/order'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode(body),
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> getSalesOrderHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/order/history'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> getSalesOrderHistoryForReturnWithSearch(
      String search, String dateFrom, String dateTo) async {
    String url = '$baseUrl/order/history';

    if (search != '') {
      url += '?search=${Uri.encodeComponent(search)}';

      if (dateFrom != '' && dateTo != '') {
        url += '&date_from=$dateFrom&date_to=$dateTo';
      }
    } else {
      if (dateFrom != '' && dateTo != '') {
        url += '?date_from=$dateFrom&date_to=$dateTo';
      }
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> deleteSalesOrderFromHistory(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/order/$id'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Returns

  Future<Map<String, dynamic>> createReturnOrder(int orderId, int paymentType,
      List<dynamic> products, int counteragentId, int dayType) async {
    Map<String, dynamic> body = {
      "type": dayType,
      "order_id": orderId,
      "payment_type": paymentType,
      "products": products,
    };

    if (counteragentId != 0) {
      body['counteragent_id'] = counteragentId;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/refund'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode(body),
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> getReturnOrderHistory(String dateFrom, String dateTo) async {
    String url = '$baseUrl/refund/history';

    if (dateFrom != '' && dateTo != '') {
      url += '?date_from=$dateFrom&date_to=$dateTo';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> deleteReturnsOrderFromHistory(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/refund/$id'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Incomings

  Future<Map<String, dynamic>> createIncomingOrder(int operation,
      List<dynamic> products, int counteragentId, int nds) async {
    Map<String, dynamic> body = {
      "payment_type": 1,
      "operation": operation,
      "products": products,
      "nds": nds,
    };

    if (counteragentId != 0) {
      body['counteragent_id'] = counteragentId;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/receipt'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode(body),
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> getIncomingOrderHistory(
      String dateFrom, String dateTo) async {
    String url = '$baseUrl/receipt/history';

    if (dateFrom != '' && dateTo != '') {
      url += '?date_from=$dateFrom&date_to=$dateTo';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<Map<String, dynamic>> editIncomingOrder(
      int id, List<dynamic> products) async {
    Map<String, dynamic> body = {
      "products": products,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/receipt/update/$id'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode(body),
    );

    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> deleteIncomingOrderFromHistory(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/receipt/$id'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Write-off (Списание)

  Future<Map<String, dynamic>> createWriteOffOrder(
      List<dynamic> products) async {
    Map<String, dynamic> body = {
      "products": products,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/reject'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode(body),
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> getWriteOffOrderHistory(
      String dateFrom, String dateTo) async {
    String url = '$baseUrl/reject/history';

    if (dateFrom != '' && dateTo != '') {
      url += '?date_from=$dateFrom&date_to=$dateTo';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> deleteWriteOffOrderFromHistory(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/reject/$id'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Return producer

  Future<Map<String, dynamic>> createReturnProducerOrder(
      List<dynamic> products, int counteragentId) async {
    Map<String, dynamic> body = {
      "payment_type": 1,
      "products": products,
    };

    if (counteragentId != 0) {
      body["counteragent_id"] = counteragentId;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/refund-producer'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode(body),
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> getReturnProducerOrderHistory(
      String dateFrom, String dateTo) async {
    String url = '$baseUrl/refund-producer/history';

    if (dateFrom != '' && dateTo != '') {
      url += '?date_from=$dateFrom&date_to=$dateTo';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> deleteReturnProducerOrderFromHistory(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/refund-producer/$id'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Moving

  Future<Map<String, dynamic>> createMovingOrder(
      int operation,
      List<dynamic> products,
      int storageId,
      int selectedOrderId,
      String comment) async {
    Map<String, dynamic> body = {
      "payment_type": 1,
      "operation": operation,
      "products": products,
      "storage_id": storageId,
      "comment": comment,
    };

    if (selectedOrderId != 0) {
      body['order_id'] = selectedOrderId;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/moving'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode(body),
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<Map<String, dynamic>> editMovingOrder(
      int id, List<dynamic> products) async {
    Map<String, dynamic> body = {
      "products": products,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/moving/update/$id'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode(body),
    );

    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> getMovingOrderHistory(String dateFrom, String dateTo) async {
    String url = '$baseUrl/moving/history';

    if (dateFrom != '' && dateTo != '') {
      url += '?date_from=$dateFrom&date_to=$dateTo';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> deleteMovingOrderFromHistory(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/moving/$id'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Inventory

  Future<dynamic> getInventoryProducts(String date, String time) async {
    final response = await http.get(
      Uri.parse('$baseUrl/inventory?date=$date&time=$time'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<Map<String, dynamic>> createInventoryOrder(
      List<dynamic> products, String date, String time) async {
    Map<String, dynamic> body = {
      "date": date,
      "time": time,
      "products": products,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/inventory'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode(body),
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<Map<String, dynamic>> editInventoryOrder(
      int id, List<dynamic> products) async {
    Map<String, dynamic> body = {
      "products": products,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/inventory/update-product/$id'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode(body),
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> getInventoryOrderHistory(
      String dateFrom, String dateTo) async {
    String url = '$baseUrl/inventory/history';
    if (dateFrom != '' && dateTo != '') {
      url += '?date_from=$dateFrom&date_to=$dateTo';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<Map<String, dynamic>> addProductToInventoryOrder(
      int productId, double count) async {
    Map<String, dynamic> body = {
      "product_id": productId,
      "count": count,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/inventory/add-receipt'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode(body),
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<Map<String, dynamic>> addProductToInventoryCreatedOrder(
      int productId, int inventoryId) async {
    Map<String, dynamic> body = {
      "product_id": productId,
      "inventory_id": inventoryId,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/inventory/add-product'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode(body),
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<Map<String, dynamic>> activateInventoryOrder(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/inventory/active/$id'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Counteragents

  Future<dynamic> getCounteragents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/counteragent'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Storages

  Future<dynamic> getStorages() async {
    final response = await http.get(
      Uri.parse('$baseUrl/storage'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Чек продажи

  Future<Map<String, dynamic>> sendDataToCheck(
    int orderId,
    int paymentType,
    double cash,
    double card,
  ) async {
    Map<String, dynamic> body = {};

    if (paymentType == 1) {
      body['payments'] = [
        {"Sum": cash, "PaymentType": 0},
      ];
    } else if (paymentType == 2) {
      body['payments'] = [
        {"Sum": card, "PaymentType": 1},
      ];
    } else {
      body['payments'] = [
        {"Sum": cash, "PaymentType": 0},
        {"Sum": card, "PaymentType": 1},
      ];
    }

    final response = await http.post(
      Uri.parse('$baseUrl/order/check/$orderId'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode(body),
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<Map<String, dynamic>> sendDataToCheckReturn(
    int orderId,
    int paymentType,
    double cash,
    double card,
  ) async {
    Map<String, dynamic> body = {};

    if (paymentType == 1) {
      body['payments'] = [
        {"Sum": cash, "PaymentType": 0},
      ];
    } else if (paymentType == 2) {
      body['payments'] = [
        {"Sum": card, "PaymentType": 1},
      ];
    } else {
      body['payments'] = [
        {"Sum": cash, "PaymentType": 0},
        {"Sum": card, "PaymentType": 1},
      ];
    }

    final response = await http.post(
      Uri.parse('$baseUrl/refund/check/$orderId'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode(body),
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Money operation

  Future<Map<String, dynamic>> sendMoneyOperationRequest(
      double sum, int operationType) async {
    final response = await http.post(
      Uri.parse('$baseUrl/webkassa/money-operation'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode({'sum': sum, 'operation_type': operationType}),
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: X отчет

  Future<Map<String, dynamic>> requestXReport() async {
    final response = await http.post(
      Uri.parse('$baseUrl/webkassa/x-report'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Z отчет

  Future<Map<String, dynamic>> requestZReport() async {
    final response = await http.post(
      Uri.parse('$baseUrl/webkassa/z-report'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> getZReports(String dateFrom, String dateTo) async {
    String url = '$baseUrl/report/z';

    if (dateFrom != '' && dateTo != '') {
      url += '?date_from=$dateFrom&date_to=$dateTo';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Report

  Future<dynamic> getRemainProducts(String dateFrom, String dateTo) async {
    String url = '$baseUrl/report/remains';
    if (dateFrom != '' && dateTo != '') {
      url += '?date_from=$dateFrom&date_to=$dateTo';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> getDiscountCardReport(
      String phone, String dateFrom, String dateTo) async {
    String url = '$baseUrl/report/discount-card';
    if (phone != '') {
      url += '?search=$phone';
      if (dateFrom != '' && dateTo != '') {
        url += '&date_from=$dateFrom&date_to=$dateTo';
      }
    } else {
      if (dateFrom != '' && dateTo != '') {
        url += '?date_from=$dateFrom&date_to=$dateTo';
      }
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> getOnlineSaleReport(String dateFrom, String dateTo) async {
    String url = '$baseUrl/report/order';

    if (dateFrom != '' && dateTo != '') {
      url += '?date_from=$dateFrom&date_to=$dateTo';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> getProductsReport(String dateFrom, String time) async {
    final response = await http.get(
      Uri.parse('$baseUrl/report/product?date=$dateFrom&time=$time'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Get ticket for printing

  Future<Map<String, dynamic>> getTicketForPrint(int orderId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/order/print-check/$orderId'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<Map<String, dynamic>> getTicketForPrintReturn(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/refund/print-check/$id'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Get and set my stores

  Future<dynamic> getMyStores() async {
    final response = await http.get(
      Uri.parse('$baseUrl/store'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> setStore(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/store'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode({'store_id': id}),
    );
    var responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  // TODO: Moderator

  Future<List<dynamic>> getCashierList() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/cashiers'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
    );
    var responseJson = jsonDecode(response.body);

    // print(responseJson);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson['message']);
    }
  }

  Future<dynamic> setStoreForCashier(int userId, int storeId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/change-store'),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "Authorization": "Bearer ${await AuthRepository().getUserToken()}",
      },
      body: jsonEncode({'user_id': userId, 'store_id': storeId}),
    );
    var responseJson = jsonDecode(response.body);

    print(responseJson);

    if (response.statusCode == 200) {
      return responseJson;
    } else {
      throw Exception(responseJson);
    }
  }
}
