import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/lens.dart';
import 'api_service.dart';

class CartService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> addToCart(
    String variantId,
    int quantity,
    Map<String, dynamic>? properties,
  ) async {
    try {
      final response = await _apiService.post('/api/shopify/cart/add', {
        'variantId': variantId,
        'quantity': quantity,
        'properties': properties ?? {},
      });
      return response;
    } catch (e) {
      print('Error adding to cart: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addMultipleToCart(
    List<Map<String, dynamic>> items,
  ) async {
    try {
      final response = await _apiService.post('/api/shopify/cart/add-multiple', {
        'items': items,
      });
      return response;
    } catch (e) {
      print('Error adding multiple items to cart: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addFrameWithLens({
    required Product frame,
    required Lens lens,
    Map<String, String>? prescriptionProperties,
  }) async {
    try {
      final items = [
        {
          'variantId': frame.variants.first.id,
          'quantity': 1,
          'properties': {
            'Frame': frame.title,
          },
        },
        {
          'variantId': lens.variantId,
          'quantity': 1,
          'properties': {
            'Lens Type': lens.categoryDisplay,
            'Lens Title': lens.title,
            ...?prescriptionProperties,
          },
        },
      ];

      return await addMultipleToCart(items);
    } catch (e) {
      print('Error adding frame with lens: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateCartItem(
    String lineItemId,
    int quantity,
  ) async {
    try {
      final response = await _apiService.post('/api/shopify/cart/update', {
        'lineItemId': lineItemId,
        'quantity': quantity,
      });
      return response;
    } catch (e) {
      print('Error updating cart: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> removeFromCart(String lineItemId) async {
    try {
      final response = await _apiService.post('/api/shopify/cart/remove', {
        'lineItemId': lineItemId,
      });
      return response;
    } catch (e) {
      print('Error removing from cart: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCart() async {
    try {
      final response = await _apiService.get('/api/shopify/cart');
      return response;
    } catch (e) {
      print('Error fetching cart: $e');
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      await _apiService.post('/api/shopify/cart/clear', {});
    } catch (e) {
      print('Error clearing cart: $e');
      rethrow;
    }
  }
}

