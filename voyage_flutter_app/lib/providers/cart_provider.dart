import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/lens.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  final CartService _cartService = CartService();
  List<CartItem> _items = [];
  bool _isLoading = false;
  String? _error;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);
  
  double get tax => subtotal * 0.18; // 18% GST
  
  double get total => subtotal + tax;

  bool get isEmpty => _items.isEmpty;

  Future<void> addItem(
    Product product, {
    int quantity = 1,
    Map<String, dynamic>? properties,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final variant = product.variants.first;
      
      await _cartService.addToCart(
        variant.id,
        quantity,
        properties,
      );

      // Add to local state
      final cartItem = CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        product: product,
        variant: variant,
        quantity: quantity,
        properties: properties,
      );

      _items.add(cartItem);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addFrameWithLens({
    required Product frame,
    required Lens lens,
    Map<String, String>? prescriptionProperties,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _cartService.addFrameWithLens(
        frame: frame,
        lens: lens,
        prescriptionProperties: prescriptionProperties,
      );

      // Add frame to local state
      final frameItem = CartItem(
        id: '${DateTime.now().millisecondsSinceEpoch}_frame',
        product: frame,
        variant: frame.variants.first,
        quantity: 1,
        properties: {'Frame': frame.title},
      );
      _items.add(frameItem);

      // Add lens to local state (create a pseudo-product for lens)
      final lensProduct = Product(
        id: lens.id,
        title: lens.title,
        handle: 'lens-${lens.id}',
        description: lens.description,
        images: lens.imageUrl != null ? [lens.imageUrl!] : [],
        minPrice: lens.price,
        maxPrice: lens.price,
        variants: [
          ProductVariant(
            id: lens.variantId,
            title: lens.title,
            price: lens.price,
            availableForSale: true,
            quantityAvailable: 100,
            selectedOptions: {},
          ),
        ],
        availableForSale: true,
        tags: [lens.category],
      );

      final lensItem = CartItem(
        id: '${DateTime.now().millisecondsSinceEpoch}_lens',
        product: lensProduct,
        variant: lensProduct.variants.first,
        quantity: 1,
        properties: {
          'Lens Type': lens.categoryDisplay,
          'Lens Title': lens.title,
          ...?prescriptionProperties,
        },
      );
      _items.add(lensItem);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    try {
      if (quantity < 1) {
        await removeItem(itemId);
        return;
      }

      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _items[index].quantity = quantity;
        notifyListeners();

        // Update on server
        await _cartService.updateCartItem(itemId, quantity);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removeItem(String itemId) async {
    try {
      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _items.removeAt(index);
        notifyListeners();

        // Remove from server
        await _cartService.removeFromCart(itemId);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> clearCart() async {
    try {
      _items.clear();
      notifyListeners();

      await _cartService.clearCart();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> refreshCart() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _cartService.getCart();
      
      // Parse cart items from response
      // TODO: Implement proper cart parsing based on Shopify response
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}

