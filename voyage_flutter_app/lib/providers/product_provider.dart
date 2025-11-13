import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/collection.dart';
import '../services/shopify_service.dart';

class ProductProvider extends ChangeNotifier {
  final ShopifyService _shopifyService = ShopifyService();
  
  List<Product> _products = [];
  Product? _currentProduct;
  List<Collection> _collections = [];
  Map<String, List<Product>> _collectionProducts = {};
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  Product? get currentProduct => _currentProduct;
  List<Collection> get collections => _collections;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts({int limit = 20}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _products = await _shopifyService.getProducts(limit: limit);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchProductById(String id) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentProduct = await _shopifyService.getProductById(id);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> fetchCollections() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _collections = await _shopifyService.getCollections();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<List<Product>> fetchCollectionProducts(String handle) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final products = await _shopifyService.getCollectionProducts(handle);
      _collectionProducts[handle] = products;
      
      _isLoading = false;
      notifyListeners();
      
      return products;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  List<Product> getCollectionProducts(String handle) {
    return _collectionProducts[handle] ?? [];
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final results = await _shopifyService.searchProducts(query);
      
      _isLoading = false;
      notifyListeners();
      
      return results;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void setCurrentProduct(Product product) {
    _currentProduct = product;
    notifyListeners();
  }

  void clearCurrentProduct() {
    _currentProduct = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

