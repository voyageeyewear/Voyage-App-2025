import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationHelper {
  static void navigateToProduct(BuildContext context, String productId) {
    Navigator.pushNamed(
      context,
      '/product',
      arguments: {'productId': productId},
    );
  }

  static void navigateToCollection(BuildContext context, String collectionHandle) {
    Navigator.pushNamed(
      context,
      '/collection',
      arguments: {'handle': collectionHandle},
    );
  }

  static void navigateToCart(BuildContext context) {
    Navigator.pushNamed(context, '/cart');
  }

  static void navigateToLensSelector(BuildContext context, dynamic product) {
    Navigator.pushNamed(
      context,
      '/lens-selector',
      arguments: {'product': product},
    );
  }

  static void navigateToSearch(BuildContext context) {
    Navigator.pushNamed(context, '/search');
  }

  static Future<void> handleUrl(String url) async {
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showLoadingDialog(BuildContext context, {String message = 'Loading...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(message),
          ],
        ),
      ),
    );
  }

  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

