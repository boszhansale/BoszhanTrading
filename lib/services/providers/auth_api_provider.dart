import 'dart:convert';

import 'package:boszhan_trading/models/response_models/login_response_model.dart';
import 'package:http/http.dart' as http;

class AuthProvider {
  final String baseUrl = 'https://backshop.boszhan.kz';
  final Map<String, String> baseHeader = {
    "Access-Control-Allow-Origin": "*",
    "Accept": "application/json",
    "Content-Type": "application/json; charset=UTF-8",
  };

  Future<LoginResponse> login(String login, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: baseHeader,
      body: jsonEncode({
        "login": login,
        "password": password,
      }),
    );

    var responseJson = jsonDecode(response.body);

    // print(responseJson);

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(responseJson);
    } else {
      throw Exception(responseJson['message']);
    }
  }
}
