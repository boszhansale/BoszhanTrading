import 'package:boszhan_trading/models/response_models/login_response_model.dart';
import 'package:boszhan_trading/models/user.dart';
import 'package:boszhan_trading/services/providers/auth_api_provider.dart';
import 'package:boszhan_trading/services/providers/session_data_provider.dart';

class AuthRepository {
  final AuthProvider _salesProvider = AuthProvider();
  final _sessionDataProvider = SessionDataProvider();

  Future<bool> isAuth() async {
    final accountId = await _sessionDataProvider.getUserId();
    final isAuth = accountId != null;
    return isAuth;
  }

  Future<LoginResponse> login(String login, String password) async =>
      _salesProvider.login(login, password);

  Future<void> logout() async {
    await _sessionDataProvider.deleteUserId();
  }

  Future<void> setUserId(int userId) async {
    await _sessionDataProvider.setUserId(userId);
  }

  Future<void> setUserToken(String token) async {
    await _sessionDataProvider.setUserToken(token);
  }

  Future<String?> getUserToken() async {
    final String? token = await _sessionDataProvider.getUserToken();
    return token;
  }

  Future<void> setUserToCache(User user) async {
    await _sessionDataProvider.setUserToCache(user);
  }

  Future<User?> getUserFromCache() async {
    return await _sessionDataProvider.getUserFromCache();
  }
}
