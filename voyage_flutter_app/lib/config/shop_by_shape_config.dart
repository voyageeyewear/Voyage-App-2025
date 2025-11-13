import '../widgets/shop_by_shape_carousel.dart';

/// Configuration for Shop By Shape section
/// 
/// To update:
/// 1. Replace imageUrl with your actual Shopify CDN URLs
/// 2. Update collectionHandle to match your Shopify collection handles
/// 3. Change titles as needed
/// 
/// Image Size: 180 × 210 pixels (recommended)
class ShopByShapeConfig {
  /// List of shape items to display
  static const List<ShapeItem> shapes = [
    ShapeItem(
      title: 'Round',
      imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/round_eb022acf-2a6d-4ea4-9d8e-cf0654c4caab.jpg?v=1750401842&width=300',
      collectionHandle: 'round-sunglasses',
    ),
    ShapeItem(
      title: 'Rectangle',
      imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/Rectangle.jpg?v=1750401842&width=300',
      collectionHandle: 'rectangle-sunglasses',
    ),
    ShapeItem(
      title: 'Wayfarer',
      imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/Wayfarer.jpg?v=1750401841&width=300',
      collectionHandle: 'wayfarer-sunglasses',
    ),
    ShapeItem(
      title: 'Cat Eye',
      imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/Cateye_3af49fba-0d31-499e-8e4b-e35f9b27d9d8.jpg?v=1750401846&width=300',
      collectionHandle: 'cat-eye-sunglasses',
    ),
  ];

  /// Section title
  static const String sectionTitle = 'Shop By Shape';

  /// Item dimensions
  static const double itemWidth = 180.0;
  static const double itemHeight = 210.0;

  /// Enable/Disable the section globally
  static const bool enabled = true;
}

