import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../utils/navigation_helper.dart';

class QuickPicksSection extends StatelessWidget {
  final List<Product> products;
  final String title;
  final VoidCallback? onViewAll;

  const QuickPicksSection({
    Key? key,
    required this.products,
    this.title = 'Quick Picks',
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and View All button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: onViewAll ?? () {
                  // Navigate to all products
                  Navigator.pushNamed(context, '/products');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View all',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: Colors.grey[800],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Horizontal Product Carousel
        SizedBox(
          height: 400, // Card height + spacing
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductCard(context, product);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, Product product) {
    // Calculate discount
    final discount = product.compareAtPrice != null
        ? double.tryParse(product.compareAtPrice!) ?? 0
        : 0;
    final savings = discount > 0 ? discount - product.minPrice : 0;

    // Calculate EMI (assuming 3 months)
    final emiPerMonth = (product.minPrice / 3).round();

    return GestureDetector(
      onTap: () => NavigationHelper.navigateToProduct(context, product.id),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Card
            Stack(
              children: [
                // Main Image Container
                Container(
                  height: 250,
                  width: 280,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2D2D), // Dark background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: product.images.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: product.images.first,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Container(
                              color: const Color(0xFF2D2D2D),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFF2D2D2D),
                              child: const Center(
                                child: Icon(
                                  Icons.image_outlined,
                                  color: Colors.white54,
                                  size: 40,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: const Color(0xFF2D2D2D),
                            child: const Center(
                              child: Icon(
                                Icons.image_outlined,
                                color: Colors.white54,
                                size: 40,
                              ),
                            ),
                          ),
                  ),
                ),

                // Discount Badge (top left)
                if (savings > 0)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B5998), // Blue badge
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Save Rs. ${savings.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                // Product Badges (top right - Polarized, UV Protected)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (product.tags.any((tag) => tag.toLowerCase().contains('polarized')))
                        _buildBadgeIcon(Icons.lens, '100%\nPOLARIZED'),
                      const SizedBox(height: 4),
                      if (product.tags.any((tag) => tag.toLowerCase().contains('uv')))
                        _buildBadgeIcon(Icons.wb_sunny_outlined, 'UV\nPROTECTED'),
                    ],
                  ),
                ),

                // Add to Cart Button (bottom right)
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.black,
                        size: 24,
                      ),
                      onPressed: () {
                        // Navigate to product detail to add to cart
                        NavigationHelper.navigateToProduct(context, product.id);
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Product Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Price and EMI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Text(
                    'Rs. ${product.minPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (discount > 0)
                    Text(
                      'Rs. ${discount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            // EMI Option
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Text(
                    'or Rs. $emiPerMonth/Month',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.credit_card,
                          size: 12,
                          color: Colors.green[700],
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Buy on EMI >',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeIcon(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: Colors.black87),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

