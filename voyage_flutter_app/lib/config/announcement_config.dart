import 'package:flutter/material.dart';
import '../widgets/announcement_bar.dart';

/// Configuration for announcement bar messages
class AnnouncementConfig {
  /// List of announcement messages to display
  static const List<AnnouncementMessage> messages = [
    AnnouncementMessage(
      text: '🎉 Free Shipping on Orders Above ₹999!',
      icon: Icons.local_shipping_outlined,
    ),
    AnnouncementMessage(
      text: '✨ New Collection Just Dropped - Shop Now!',
      icon: Icons.new_releases_outlined,
    ),
    AnnouncementMessage(
      text: '💎 Premium Quality Eyewear - Upto 70% Off',
      icon: Icons.discount_outlined,
    ),
  ];

  /// Bar height
  static const double barHeight = 38.0;
  
  /// Marquee scroll speed (pixels per second)
  static const double scrollSpeed = 30.0;

  /// Enable/Disable announcement bar globally
  static const bool enabled = true;
}

