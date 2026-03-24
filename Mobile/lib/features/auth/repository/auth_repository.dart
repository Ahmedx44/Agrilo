import 'package:agrilo/core/services/api_client.dart';
import 'package:agrilo/core/services/storage_service.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Map<String, String>> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data['token'] as String;
        final name = response.data['user']?['name'] as String? ?? 'Farmer';
        await StorageService.saveUserName(name);
        return {'token': token, 'name': name};
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String>> register(String name, String email, String password) async {
    try {
      final response = await _apiClient.post(
        '/api/auth/register',
        data: {'name': name, 'email': email, 'password': password},
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data['token'] as String;
        await StorageService.saveUserName(name);
        return {'token': token, 'name': name};
      } else {
        throw Exception(response.data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  void setAuthToken(String token) {
    _apiClient.setAuthToken(token);
  }

  void clearAuthToken() {
    _apiClient.clearAuthToken();
  }
}
