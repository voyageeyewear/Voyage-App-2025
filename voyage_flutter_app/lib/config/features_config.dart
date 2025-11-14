import 'package:flutter/material.dart';
import '../widgets/features_carousel.dart';

class FeaturesConfig {
  static const bool enabled = true;

  static const List<FeatureItem> features = [
    FeatureItem(
      icon: Icons.local_shipping_outlined,
      title: 'Free Shipping',
      description: 'On orders above ₹999',
    ),
    FeatureItem(
      icon: Icons.refresh_outlined,
      title: '7 Days Return',
      description: 'Easy return policy',
    ),
    FeatureItem(
      icon: Icons.verified_outlined,
      title: '100% Authentic',
      description: 'Genuine products only',
    ),
  ];

  static const Duration autoPlayDuration = Duration(seconds: 3);
}

