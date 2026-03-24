import 'package:agrilo/core/services/api_client.dart';

class DashboardRepository {
  final ApiClient _apiClient;

  DashboardRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final response = await _apiClient.get('/api/dashboard');
      if (response.statusCode == 200) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load dashboard data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
