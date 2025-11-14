import 'package:flutter/material.dart';
import '../widgets/service_benefits_slider.dart';

class ServiceBenefitsConfig {
  static const bool enabled = true;

  static const List<ServiceBenefitItem> benefits = [
    ServiceBenefitItem(
      icon: Icons.refresh_outlined,
      title: '7 Days Return',
      description: 'Easy return policy',
    ),
    ServiceBenefitItem(
      icon: Icons.headset_mic_outlined,
      title: 'Customer Service',
      description:
          'Personalized and exceptional assistance for a seamless experience.',
    ),
    ServiceBenefitItem(
      icon: Icons.people_outline,
      title: 'Refer a Friend',
      description:
          'Share Voyage Eyewear with friends and enjoy exclusive rewards together.',
    ),
    ServiceBenefitItem(
      icon: Icons.lock_outline,
      title: 'Secure Payment',
      description:
          'Transactions protected by robust and secure payment methods.',
    ),
  ];
}

