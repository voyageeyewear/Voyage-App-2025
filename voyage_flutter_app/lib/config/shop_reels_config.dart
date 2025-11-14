class ShopReelsConfig {
  static const bool enabled = true;

  static const String title = 'Shop Our Reels';
  static const String subtitle = 'Discover our products through video';

  // Add your video URLs here
  // These should be direct video file URLs (mp4, etc.)
  static const List<String> videoUrls = [
    'https://cdn.shopify.com/videos/c/o/v/213358b22f234e83a0519211afe4d1e4.mp4',
    'https://cdn.shopify.com/videos/c/o/v/9e05d968facd4ab7ad58ff41fed0866f.mp4',
    'https://cdn.shopify.com/videos/c/o/v/a8c07b61702f4aad81a16e0cf8d9429c.mp4',
    'https://cdn.shopify.com/videos/c/o/v/d2d9a02b2555445ab39851dffb4eb7e2.mp4',
  ];

  // Aspect ratio for video cards (9:16 for vertical reels)
  static const double aspectRatio = 9 / 16;
  
  // Card width
  static const double cardWidth = 280;
}

