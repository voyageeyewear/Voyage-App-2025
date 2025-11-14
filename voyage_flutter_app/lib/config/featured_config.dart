import 'package:flutter/material.dart';
import '../widgets/as_featured_section.dart';

/// Configuration for the "As Featured On" section.
///
/// To customize:
/// 1. Update imageUrl with your media logo URLs
/// 2. Update name for accessibility
/// 3. Add onTap callbacks for navigation if needed
class FeaturedConfig {
  /// List of media logos to display
  static const List<FeaturedLogoItem> logos = [
    FeaturedLogoItem(
      imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/Artboard_6.jpg?v=1719569829&width=200',
      name: 'Economic Times',
    ),
    FeaturedLogoItem(
      imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/Artboard_1_copy_9.jpg?v=1719569829&width=200',
      name: 'The Times of India',
    ),
    FeaturedLogoItem(
      imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/Artboard_1_copy_2.jpg?v=1719569829&width=200',
      name: 'News18',
    ),
  ];

  /// Section title
  static const String sectionTitle = 'As Featured On';

  /// Enable/Disable section globally
  static const bool enabled = true;
}

