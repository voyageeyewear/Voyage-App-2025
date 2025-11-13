import 'api_service.dart';

class CheckoutService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> createCheckout(String cartId) async {
    try {
      final response = await _apiService.post('/api/shopify/checkout/create', {
        'cartId': cartId,
      });
      return response;
    } catch (e) {
      print('Error creating checkout: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createGokwikCheckout({
    required String cartId,
    required String email,
    required String phone,
  }) async {
    try {
      final response = await _apiService.post('/api/shopify/checkout/gokwik', {
        'cartId': cartId,
        'customerInfo': {
          'email': email,
          'phone': phone,
        },
      });
      return response;
    } catch (e) {
      print('Error creating Gokwik checkout: $e');
      rethrow;
    }
  }
}

