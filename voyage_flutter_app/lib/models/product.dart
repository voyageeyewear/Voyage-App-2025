class Product {
  final String id;
  final String title;
  final String handle;
  final String description;
  final List<String> images;
  final double minPrice;
  final double maxPrice;
  final String? compareAtPrice;
  final List<ProductVariant> variants;
  final bool availableForSale;
  final List<String> tags;
  final String? vendor;

  Product({
    required this.id,
    required this.title,
    required this.handle,
    required this.description,
    required this.images,
    required this.minPrice,
    required this.maxPrice,
    this.compareAtPrice,
    required this.variants,
    required this.availableForSale,
    required this.tags,
    this.vendor,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final priceRange = json['priceRange'] ?? {};
    final minVariantPrice = priceRange['minVariantPrice'] ?? {};
    final maxVariantPrice = priceRange['maxVariantPrice'] ?? {};

    return Product(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      handle: json['handle']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((img) {
                if (img is Map) {
                  return img['url']?.toString() ?? '';
                } else if (img is String) {
                  return img;
                }
                return '';
              })
              .where((url) => url.isNotEmpty)
              .toList() ??
          [],
      minPrice: double.tryParse(minVariantPrice['amount']?.toString() ?? '0') ?? 0,
      maxPrice: double.tryParse(maxVariantPrice['amount']?.toString() ?? '0') ?? 0,
      compareAtPrice: json['compareAtPriceRange']?['minVariantPrice']?['amount']?.toString(),
      variants: (json['variants'] as List<dynamic>?)
              ?.map((v) => ProductVariant.fromJson(v))
              .toList() ??
          [],
      availableForSale: json['availableForSale'] ?? true,
      tags: (json['tags'] as List<dynamic>?)?.map((t) => t.toString()).toList() ?? [],
      vendor: json['vendor']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'handle': handle,
      'description': description,
      'images': images.map((img) => {'url': img}).toList(),
      'priceRange': {
        'minVariantPrice': {'amount': minPrice.toString()},
        'maxVariantPrice': {'amount': maxPrice.toString()},
      },
      'variants': variants.map((v) => v.toJson()).toList(),
      'availableForSale': availableForSale,
      'tags': tags,
      'vendor': vendor,
    };
  }

  String get displayPrice {
    if (minPrice == maxPrice) {
      return '₹${minPrice.toStringAsFixed(0)}';
    }
    return '₹${minPrice.toStringAsFixed(0)} - ₹${maxPrice.toStringAsFixed(0)}';
  }

  double? get discountPercentage {
    if (compareAtPrice != null) {
      final compare = double.tryParse(compareAtPrice!);
      if (compare != null && compare > minPrice) {
        return ((compare - minPrice) / compare * 100);
      }
    }
    return null;
  }
}

class ProductVariant {
  final String id;
  final String title;
  final double price;
  final String? compareAtPrice;
  final bool availableForSale;
  final int quantityAvailable;
  final String? sku;
  final Map<String, String> selectedOptions;

  ProductVariant({
    required this.id,
    required this.title,
    required this.price,
    this.compareAtPrice,
    required this.availableForSale,
    required this.quantityAvailable,
    this.sku,
    required this.selectedOptions,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    final priceData = json['price'] ?? json['priceV2'] ?? {};
    
    // Parse selectedOptions safely
    Map<String, String> parseSelectedOptions(dynamic options) {
      if (options == null) return {};
      if (options is Map) {
        return options.map((key, value) => 
          MapEntry(key.toString(), value?.toString() ?? ''));
      }
      return {};
    }
    
    return ProductVariant(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      price: double.tryParse(priceData['amount']?.toString() ?? '0') ?? 0,
      compareAtPrice: json['compareAtPrice']?['amount']?.toString(),
      availableForSale: json['availableForSale'] ?? true,
      quantityAvailable: json['quantityAvailable'] ?? 0,
      sku: json['sku']?.toString(),
      selectedOptions: parseSelectedOptions(json['selectedOptions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': {'amount': price.toString()},
      'compareAtPrice': compareAtPrice != null ? {'amount': compareAtPrice} : null,
      'availableForSale': availableForSale,
      'quantityAvailable': quantityAvailable,
      'sku': sku,
      'selectedOptions': selectedOptions,
    };
  }
}

