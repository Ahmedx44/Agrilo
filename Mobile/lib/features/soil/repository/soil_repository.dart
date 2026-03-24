import 'dart:io';

import 'package:agrilo/core/services/api_client.dart';
import 'package:dio/dio.dart';

class SoilRepository {
  final ApiClient _apiClient;

  SoilRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<void> analyzeSoil(File image) async {
    try {
      final String fileName = image.path.split('/').last;
      
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: fileName,
        ),
      });

      final response = await _apiClient.post(
        '/api/soil/analyze',
        data: formData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(response.data['message'] ?? 'Failed to analyze soil');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getHistory() async {
    try {
      final response = await _apiClient.get('/api/soil/history');
      if (response.statusCode == 200) {
        return response.data['data'] as List<dynamic>;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch history');
      }
    } catch (e) {
      rethrow;
    }
  }
}
