import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../utils/constants.dart';
import '../utils/navigation_helper.dart';
import '../utils/html_helper.dart';
import 'product_image_viewer.dart';

class FeaturedProductSection extends StatefulWidget {
  final Product product;
  final String? sectionTitle;

  const FeaturedProductSection({
    Key? key,
    required this.product,
    this.sectionTitle,
  }) : super(key: key);

  @override
  State<FeaturedProductSection> createState() => _FeaturedProductSectionState();
}

class _FeaturedProductSectionState extends State<FeaturedProductSection> {
  final PageController _imageController = PageController();
  int _quantity = 1;
  bool _isDescriptionExpanded = false;

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addToCart() {
    final cartProvider = context.read<CartProvider>();
    
    try {
      cartProvider.addItem(
        widget.product,
        quantity: _quantity,
      );

      NavigationHelper.showSnackBar(
        context,
        '✓ Added to cart',
        isError: false,
      );
    } catch (e) {
      NavigationHelper.showSnackBar(
        context,
        'Failed to add to cart',
        isError: true,
      );
    }
  }

  void _buyNow() {
    _addToCart();
    // Navigate to cart or checkout
    NavigationHelper.navigateToCart(context);
  }

  @override
  Widget build(BuildContext context) {
    final discount = widget.product.compareAtPrice != null
        ? double.tryParse(widget.product.compareAtPrice!) ?? 0
        : 0;
    final savings = discount > 0 ? discount - widget.product.minPrice : 0;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Carousel
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PageView.builder(
                  controller: _imageController,
                  itemCount: widget.product.images.isNotEmpty
                      ? widget.product.images.length
                      : 1,
                  itemBuilder: (context, index) {
                    if (widget.product.images.isEmpty) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                      );
                    }
                    return CachedNetworkImage(
                      imageUrl: widget.product.images[index],
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[100],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.error,
                          color: Colors.grey,
                          size: 64,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Zoom Icon
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    if (widget.product.images.isNotEmpty) {
                      ProductImageViewer.show(
                        context,
                        images: widget.product.images,
                        initialIndex: _imageController.hasClients
                            ? _imageController.page?.round() ?? 0
                            : 0,
                      );
                    }
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.zoom_in,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Page Indicators
          if (widget.product.images.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SmoothPageIndicator(
                  controller: _imageController,
                  count: widget.product.images.length,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.black,
                    dotColor: Colors.grey,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Vendor
          if (widget.product.vendor != null)
            Text(
              widget.product.vendor!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w400,
              ),
            ),

          const SizedBox(height: 8),

          // Product Title
          Text(
            widget.product.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 16),

          // Price Row
          Row(
            children: [
              Text(
                'Rs. ${widget.product.minPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              if (discount > 0) ...[
                const SizedBox(width: 12),
                Text(
                  'Rs. ${discount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[500],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 32),

          // Divider
          Divider(color: Colors.grey[300], thickness: 1),

          const SizedBox(height: 24),

          // Quantity Selector
          Row(
            children: [
              const Text(
                'Quantity:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.remove, size: 20),
                  onPressed: _decrementQuantity,
                  color: Colors.black,
                ),
                Container(
                  constraints: const BoxConstraints(minWidth: 60),
                  alignment: Alignment.center,
                  child: Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: _incrementQuantity,
                  color: Colors.black,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Add to Cart Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: _addToCart,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                backgroundColor: Colors.white,
              ),
              child: const Text(
                'Add to cart',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Buy Now Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _buyNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Buy Now',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Divider
          Divider(color: Colors.grey[300], thickness: 1),

          // Description Section
          InkWell(
            onTap: () {
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isDescriptionExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Description Content (Collapsible)
          if (_isDescriptionExpanded && widget.product.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                HtmlHelper.parseHtml(widget.product.description),
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
            ),

          Divider(color: Colors.grey[300], thickness: 1),
        ],
      ),
    );
  }
}

