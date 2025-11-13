import '../widgets/celebrity_spotted_section.dart';

/// Configuration for Celebrity Spotted section
/// 
/// To update:
/// 1. Replace imageUrl with your celebrity images
/// 2. Update name for each celebrity
/// 3. Add url or custom onTap handler for navigation
/// 
/// Image Size: 180 × 180 pixels
class CelebrityConfig {
  /// List of celebrity items to display
  static const List<CelebrityItem> celebrities = [
    CelebrityItem(
      name: 'Maniesh',
      imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/MANIESH.jpg?v=1720086719&width=400',
      url: '/celebrity/maniesh',
    ),
    CelebrityItem(
      name: 'Aditya',
      imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/ADITYA_d1db9abd-f6a3-4119-9d36-77766d247bcd.jpg?v=1720086720&width=400',
      url: '/celebrity/aditya',
    ),
    CelebrityItem(
      name: 'Prince',
      imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/PRINCE_d25512d9-66e8-408c-93ee-47f22f46b919.jpg?v=1720086719&width=400',
      url: '/celebrity/prince',
    ),
    CelebrityItem(
      name: 'Karan',
      imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/KARAN.jpg?v=1720086719&width=400',
      url: '/celebrity/karan',
    ),
    CelebrityItem(
      name: 'Celebrity 5',
      imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/457594491_18337491109133807_3858259328606589632_n.jpg?v=1725429893&width=300',
      url: '/celebrity/celebrity5',
    ),
  ];

  /// Section title
  static const String sectionTitle = 'Celebrity Spotted';

  /// Image size (square)
  static const double imageSize = 180.0;

  /// Enable/Disable the section globally
  static const bool enabled = true;
}

