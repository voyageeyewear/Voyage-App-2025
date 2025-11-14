import 'package:flutter/material.dart';

class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'https://voyage-app-2025-production.up.railway.app';  // Railway deployment (works everywhere!)
  static const String storeDomain = 'voyage-eyewear.myshopify.com';
  
  // App Information
  static const String appName = 'Voyage Eyewear';
  static const String appVersion = '1.0.0';
  
  // Theme Colors
  static const Color primaryColor = Color(0xFF2C3E50);  // Dark Blue-Grey
  static const Color secondaryColor = Color(0xFFE74C3C);  // Elegant Red
  static const Color accentColor = Color(0xFF3498DB);  // Bright Blue
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color textPrimaryColor = Color(0xFF2C3E50);
  static const Color textSecondaryColor = Color(0xFF7F8C8D);
  
  // Timeouts
  static const Duration requestTimeout = Duration(seconds: 15);  // Reduced for faster error detection
  static const Duration cacheTimeout = Duration(hours: 1);
  
  // Pagination
  static const int productsPerPage = 20;
  static const int maxCacheSize = 100;
  
  // Price Format
  static String formatPrice(double price) {
    return '₹${price.toStringAsFixed(0)}';
  }
  
  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String productNotFound = 'Product not found.';
  static const String cartEmpty = 'Your cart is empty.';
}

