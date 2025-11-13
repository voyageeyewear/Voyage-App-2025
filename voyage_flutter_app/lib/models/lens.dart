class Lens {
  final String id;
  final String title;
  final double price;
  final String description;
  final List<String> features;
  final String category;  // 'antiglare', 'blueblock', 'colour'
  final String variantId;
  final String? imageUrl;

  Lens({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.features,
    required this.category,
    required this.variantId,
    this.imageUrl,
  });

  factory Lens.fromJson(Map<String, dynamic> json) {
    // Extract features from description
    List<String> features = [];
    if (json['description'] != null) {
      final desc = json['description'] as String;
      if (desc.contains('•')) {
        features = desc
            .split('•')
            .where((f) => f.trim().isNotEmpty)
            .map((f) => f.trim())
            .toList();
      }
    }

    return Lens(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0,
      description: json['description'] ?? '',
      features: features.isNotEmpty ? features : ['Premium quality lens'],
      category: json['category'] ?? 'general',
      variantId: json['variantId'] ?? json['id'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'features': features,
      'category': category,
      'variantId': variantId,
      'imageUrl': imageUrl,
    };
  }

  String get displayPrice => '₹${price.toStringAsFixed(0)}';

  String get categoryDisplay {
    switch (category.toLowerCase()) {
      case 'antiglare':
        return 'Anti-Glare Lens';
      case 'blueblock':
        return 'Blue Block Lens';
      case 'colour':
        return 'Colour Lens';
      default:
        return 'Lens';
    }
  }
}

class PrescriptionData {
  final double? rightSph;
  final double? rightCyl;
  final int? rightAxis;
  final double? rightAdd;
  final double? leftSph;
  final double? leftCyl;
  final int? leftAxis;
  final double? leftAdd;

  PrescriptionData({
    this.rightSph,
    this.rightCyl,
    this.rightAxis,
    this.rightAdd,
    this.leftSph,
    this.leftCyl,
    this.leftAxis,
    this.leftAdd,
  });

  Map<String, String> toProperties() {
    final Map<String, String> props = {};
    
    if (rightSph != null) props['Right SPH'] = rightSph.toString();
    if (rightCyl != null) props['Right CYL'] = rightCyl.toString();
    if (rightAxis != null) props['Right Axis'] = rightAxis.toString();
    if (rightAdd != null) props['Right ADD'] = rightAdd.toString();
    if (leftSph != null) props['Left SPH'] = leftSph.toString();
    if (leftCyl != null) props['Left CYL'] = leftCyl.toString();
    if (leftAxis != null) props['Left Axis'] = leftAxis.toString();
    if (leftAdd != null) props['Left ADD'] = leftAdd.toString();
    
    return props;
  }

  bool get isValid {
    return rightSph != null || leftSph != null;
  }
}

