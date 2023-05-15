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

  Future<dynamic> getProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/product'),
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
      List<dynamic> products, int counteragentId) async {
    Map<String, dynamic> body = {
      "online_sale": onlineSale,
      "payment_type": paymentType,
      "products": products,
    };

    if (counteragentId != 0) {
      body['counteragent_id'] = counteragentId;
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

  Future<dynamic> getReturnOrderHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/refund/history'),
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

  Future<Map<String, dynamic>> createIncomingOrder(int operation, String bank,
      List<dynamic> products, int counteragentId) async {
    Map<String, dynamic> body = {
      "payment_type": 1,
      "operation": operation,
      "bank": bank,
      "products": products,
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

  Future<dynamic> getIncomingOrderHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/receipt/history'),
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
      "payment_type": 1,
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

  Future<dynamic> getWriteOffOrderHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reject/history'),
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
      List<dynamic> products) async {
    Map<String, dynamic> body = {
      "payment_type": 1,
      "products": products,
    };

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

  Future<dynamic> getReturnProducerOrderHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/refund-producer/history'),
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
}
