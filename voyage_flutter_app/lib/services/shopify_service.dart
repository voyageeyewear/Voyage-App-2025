import '../models/product.dart';
import '../models/collection.dart';
import '../models/lens.dart';
import 'api_service.dart';

class ShopifyService {
  final ApiService _apiService = ApiService();

  // Products
  Future<List<Product>> getProducts({int limit = 20}) async {
    try {
      final response = await _apiService.get('/api/shopify/products?limit=$limit');
      final products = (response['products'] as List)
          .map((json) => Product.fromJson(json))
          .toList();
      return products;
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final response = await _apiService.get('/api/shopify/products/$id');
      return Product.fromJson(response['product']);
    } catch (e) {
      print('Error fetching product: $e');
      rethrow;
    }
  }

  Future<List<Product>> getCollectionProducts(String handle) async {
    try {
      final response = await _apiService.get('/api/shopify/products/collection/$handle');
      final products = (response['products'] as List)
          .map((json) => Product.fromJson(json))
          .toList();
      return products;
    } catch (e) {
      print('Error fetching collection products: $e');
      rethrow;
    }
  }

  // Collections
  Future<List<Collection>> getCollections() async {
    try {
      final response = await _apiService.get('/api/shopify/collections');
      final collections = (response['collections'] as List)
          .map((json) => Collection.fromJson(json))
          .toList();
      return collections;
    } catch (e) {
      print('Error fetching collections: $e');
      rethrow;
    }
  }

  // Search
  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _apiService.get('/api/shopify/search?q=$query');
      final products = (response['results'] as List)
          .map((json) => Product.fromJson(json))
          .toList();
      return products;
    } catch (e) {
      print('Error searching products: $e');
      rethrow;
    }
  }

  // Lens Options
  Future<Map<String, List<Lens>>> getLensOptions() async {
    try {
      final response = await _apiService.get('/api/shopify/lens-options');
      
      return {
        'antiglare': (response['antiGlareLenses'] as List)
            .map((json) => Lens.fromJson(json))
            .toList(),
        'blueblock': (response['blueBlockLenses'] as List)
            .map((json) => Lens.fromJson(json))
            .toList(),
        'colour': (response['colourLenses'] as List)
            .map((json) => Lens.fromJson(json))
            .toList(),
        'all': (response['allLenses'] as List)
            .map((json) => Lens.fromJson(json))
            .toList(),
      };
    } catch (e) {
      print('Error fetching lens options: $e');
      rethrow;
    }
  }

  // Theme Sections (Homepage data)
  Future<Map<String, dynamic>> getThemeSections() async {
    try {
      final response = await _apiService.get('/api/shopify/theme-sections');
      return response;
    } catch (e) {
      print('Error fetching theme sections: $e');
      rethrow;
    }
  }

  // Shop Info
  Future<Map<String, dynamic>> getShopInfo() async {
    try {
      final response = await _apiService.get('/api/shopify/shop');
      return response;
    } catch (e) {
      print('Error fetching shop info: $e');
      rethrow;
    }
  }
}

