import 'dart:convert';

import 'package:boszhan_trading/services/repositories/auth_repository.dart';
import 'package:http/http.dart' as http;

class MainApiService {
  final String baseUrl = 'http://back_shop.boszhan.kz/api';

  // TODO: Brands, Categories, Products

  Future<dynamic> getBrands() async {
    final response = await http.get(
      Uri.parse('$baseUrl/brand'),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
      List<dynamic> products, int counteragentId) async {
    Map<String, dynamic> body = {
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
        "Content-Type": "application/json; charset=UTF-8",
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
