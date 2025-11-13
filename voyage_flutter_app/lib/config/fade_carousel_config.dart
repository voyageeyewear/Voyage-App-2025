import '../widgets/fade_carousel.dart';

/// Configuration for Fade Carousel section
/// 
/// Image Size: 1400 × 500 pixels
/// Animation: Fade in/fade out
class FadeCarouselConfig {
  /// List of carousel items
  static const List<FadeCarouselItem> items = [
    FadeCarouselItem(
      imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/Artboard_4_1.jpg?v=1755552785&width=800',
    ),
    FadeCarouselItem(
      imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/RADAR_mob_copy.jpg?v=1743592286&width=800',
    ),
  ];

  /// Carousel dimensions
  static const double width = double.infinity; // Full width
  static const double height = 500.0; // Height in pixels (scaled from 1400×500)

  /// Auto-play duration (time between slides)
  static const Duration duration = Duration(seconds: 5);

  /// Fade animation duration
  static const Duration fadeDuration = Duration(milliseconds: 1000);

  /// Enable/Disable the section globally
  static const bool enabled = true;
}

