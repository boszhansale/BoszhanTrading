import 'dart:convert';

import 'package:boszhan_trading/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const _userId = 'user_id';
  static const _userToken = 'user_token';
  static const _userData = 'user_data';
  static const _productData = 'product_data';
}

class SessionDataProvider {
  static const secureStorage = FlutterSecureStorage();

  Future<int?> getUserId() async {
    final id = await secureStorage.read(key: _Keys._userId);
    return id != null ? int.tryParse(id) : null;
  }

  Future<void> setUserId(int accountId) async {
    await secureStorage.write(key: _Keys._userId, value: accountId.toString());
  }

  Future<void> deleteUserId() {
    return secureStorage.delete(key: _Keys._userId);
  }

  Future<String?> getUserToken() async {
    final token = await secureStorage.read(key: _Keys._userToken);
    return token;
  }

  Future<void> setUserToken(String token) async {
    await secureStorage.write(key: _Keys._userToken, value: token);
  }

  Future<void> deleteUserToken() {
    return secureStorage.delete(key: _Keys._userToken);
  }

  Future<void> setUserToCache(User user) async {
    await secureStorage.write(
        key: _Keys._userData, value: jsonEncode(user.toJson()));
  }

  Future<User?> getUserFromCache() async {
    final userString = await secureStorage.read(key: _Keys._userData);
    final user =
        userString != null ? User.fromJson(jsonDecode(userString)) : null;
    return user;
  }

  Future<void> setProductsToCache(List<Map<String, dynamic>> products) async {
    await secureStorage.write(
        key: _Keys._productData, value: jsonEncode(products));
  }

  Future<List<dynamic>?> getProductsFromCache() async {
    final productsString = await secureStorage.read(key: _Keys._productData);
    final products = productsString != null ? jsonDecode(productsString) : null;
    return products;
  }
}
