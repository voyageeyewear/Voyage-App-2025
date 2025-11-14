import 'package:flutter/material.dart';
import '../widgets/service_benefits_slider.dart';

class ServiceBenefitsConfig {
  static const bool enabled = true;

  static const List<ServiceBenefitItem> benefits = [
    ServiceBenefitItem(
      icon: Icons.refresh_outlined,
      title: '7 Days Return',
      description: 'Enjoy worry-free shopping with our smooth, 7-day return window.',
    ),
    ServiceBenefitItem(
      icon: Icons.headset_mic_outlined,
      title: 'Customer Service',
      description:
          'Experience personalized and exceptional support from our friendly, knowledgeable team.',
    ),
    ServiceBenefitItem(
      icon: Icons.loyalty_outlined,
      title: 'Refer a Friend',
      description:
          'Share the Voyage experience with friends and unlock exclusive rewards for both of you.',
    ),
    ServiceBenefitItem(
      icon: Icons.lock_outline,
      title: 'Secure Payment',
      description:
          'Shop with peace of mind knowing your personal and financial information is protected.',
    ),
  ];
}

