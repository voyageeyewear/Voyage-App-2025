import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static const String baseUrl = AppConstants.apiBaseUrl;
  final http.Client _client = http.Client();

  Future<dynamic> get(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('GET Request: $url');

      final response = await _client
          .get(
            url,
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(AppConstants.requestTimeout);

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timeout. Please check your connection.');
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('POST Request: $url');
      print('Body: ${jsonEncode(body)}');

      final response = await _client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(AppConstants.requestTimeout);

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timeout. Please check your connection.');
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('PUT Request: $url');

      final response = await _client
          .put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(AppConstants.requestTimeout);

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timeout. Please check your connection.');
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('DELETE Request: $url');

      final response = await _client
          .delete(
            url,
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(AppConstants.requestTimeout);

      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException('Request timeout. Please check your connection.');
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw ApiException('Resource not found', statusCode: 404);
    } else if (response.statusCode >= 500) {
      throw ApiException('Server error. Please try again later.',
          statusCode: response.statusCode);
    } else {
      final error = jsonDecode(response.body);
      throw ApiException(
        error['message'] ?? 'Request failed',
        statusCode: response.statusCode,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}

