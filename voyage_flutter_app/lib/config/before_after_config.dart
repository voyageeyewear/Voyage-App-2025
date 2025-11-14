/// Configuration for the Before/After image comparison section.
///
/// To customize:
/// 1. Update image URLs with your product photos
/// 2. Change title and subtitle
/// 3. Add description if needed
/// 4. Adjust initial drag position (0.0 to 1.0)
class BeforeAfterConfig {
  /// Section title
  static const String title = 'From Ordinary to Extraordinary:\nUnveiling a Whole New Look';

  /// Section subtitle (optional)
  static const String? subtitle = null;

  /// Section description (optional)
  static const String? description = null;

  /// Before image URL (dark/lifestyle scene)
  static const String beforeImage = 
      'https://cdn.shopify.com/s/files/1/0238/8312/0717/files/31_3290cb03-cb20-49a8-8d69-dd92b39a920c.jpg?v=1686918425';

  /// After image URL (light/lifestyle scene)
  static const String afterImage = 
      'https://cdn.shopify.com/s/files/1/0238/8312/0717/files/32_ad6c5ef7-0539-4489-b1b6-5448e37ab5b0.jpg?v=1686918425';

  /// Before text label
  static const String? beforeText = null;

  /// After text label
  static const String? afterText = null;

  /// Initial drag position (0.0 = fully before, 1.0 = fully after, 0.5 = middle)
  static const double initialDragPosition = 0.5;

  /// Enable/Disable section globally
  static const bool enabled = true;
}

