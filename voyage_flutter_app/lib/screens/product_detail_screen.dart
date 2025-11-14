import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../utils/constants.dart';
import '../utils/navigation_helper.dart';
import '../utils/html_helper.dart';
import '../widgets/product_image_viewer.dart';
import '../widgets/announcement_bar.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/search_drawer.dart';
import '../widgets/shop_reels_section.dart';
import '../widgets/footer_section.dart';
import '../config/announcement_config.dart';
import '../config/shop_reels_config.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _imageController = PageController();
  int _currentImageIndex = 0;
  int _quantity = 1;
  bool _isLoading = true;
  Product? _product;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() => _isLoading = true);
    
    try {
      final productProvider = context.read<ProductProvider>();
      
      Product? product = productProvider.products.firstWhere(
        (p) => p.id == widget.productId,
        orElse: () => productProvider.products.first,
      );

      setState(() {
        _product = product;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  void _addToCart() {
    if (_product == null) return;

    final cartProvider = context.read<CartProvider>();
    
    try {
      cartProvider.addItem(_product!, quantity: _quantity);

      NavigationHelper.showSnackBar(
        context,
        '✓ Added $_quantity ${_quantity > 1 ? "items" : "item"} to cart',
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
    NavigationHelper.navigateToCart(context);
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

  double get _currentPrice => _product?.minPrice ?? 0;
  
  double? get _compareAtPrice {
    if (_product?.compareAtPrice != null) {
      return double.tryParse(_product!.compareAtPrice!);
    }
    return null;
  }

  double get _savings {
    if (_compareAtPrice != null && _compareAtPrice! > _currentPrice) {
      return _compareAtPrice! - _currentPrice;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_product == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Product not found'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + AnnouncementConfig.barHeight),
          child: Column(
            children: [
              // Announcement Bar at the top
              if (AnnouncementConfig.enabled)
                AnnouncementBar(
                  messages: AnnouncementConfig.messages,
                  backgroundColor: AppConstants.primaryColor,
                  textColor: Colors.white,
                  height: AnnouncementConfig.barHeight,
                  scrollSpeed: AnnouncementConfig.scrollSpeed,
                ),
              
              // App Header below announcement
              AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.menu, size: 24, color: Colors.black),
                  onPressed: () {
                    NavigationDrawerWidget.show(context);
                  },
                  padding: EdgeInsets.zero,
                ),
                leadingWidth: 100,
                title: Image.network(
                  'https://www.voyageeyewear.com/cdn/shop/files/Voyage_hindi_2.png?v=1720597430&width=350',
                  height: 26,
                  fit: BoxFit.contain,
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search, size: 24, color: Colors.black),
                    onPressed: () => SearchDrawerWidget.show(context),
                    padding: EdgeInsets.zero,
                  ),
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined, size: 24, color: Colors.black),
                            onPressed: () => NavigationHelper.navigateToCart(context),
                            padding: EdgeInsets.zero,
                          ),
                          if (cart.itemCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppConstants.secondaryColor,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${cart.itemCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ],
          ),
        ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image Carousel
                  _buildImageCarousel(),

                  // Product Info
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Title
                        Text(
                          _product!.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Price + Compare + Savings Badge in one line
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Rs. ${_currentPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            if (_compareAtPrice != null) ...[
                              const SizedBox(width: 6),
                              Text(
                                'Rs. ${_compareAtPrice!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[500],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                            if (_savings > 0) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4267B2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'Save Rs. ${_savings.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Quantity Selector
                        _buildQuantitySelector(),

                        const SizedBox(height: 16),

                        // Collapsible Description
                        _buildCollapsibleSection(
                          title: 'Description',
                          content: _product!.description.isNotEmpty
                              ? HtmlHelper.parseHtml(_product!.description)
                              : 'No description available.',
                        ),

                        const Divider(height: 1, thickness: 1),

                        // Collapsible Return Policy
                        _buildCollapsibleSection(
                          title: 'Return policy',
                          content: 'Easy returns within 7 days of delivery. Product must be unused and in original packaging.',
                        ),

                        const SizedBox(height: 24),

                        // Tags
                        if (_product!.tags.isNotEmpty) ...[
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _product!.tags.take(5).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  tag.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ),

                  // Shop Our Reels Section
                  if (ShopReelsConfig.enabled)
                    const ShopReelsSection(
                      videoUrls: ShopReelsConfig.videoUrls,
                      title: ShopReelsConfig.title,
                      subtitle: ShopReelsConfig.subtitle,
                    ),

                  const SizedBox(height: 16),
                  const ReelsPromoBanner(),

                  const SizedBox(height: 24),
                  YouMayAlsoLikeSection(
                    products: productProvider.products,
                  ),

                  const SizedBox(height: 32),
                  FooterSection(),
                ],
              ),
            ),
          ),

          // Bottom Section - Sticky Cart
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Promotional Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFDDB6B6), // Light brown/salmon
                    ),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4A4A4A),
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Get at ',
                            ),
                            TextSpan(
                              text: '₹${(_currentPrice - 150).toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const TextSpan(
                              text: ' by using ',
                            ),
                            const TextSpan(
                              text: 'GRAB150',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Price and Buttons Row
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Left Side - Price Info
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Rs. ${_currentPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              if (_compareAtPrice != null)
                                Text(
                                  'Rs. ${_compareAtPrice!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              const SizedBox(height: 1),
                              Text(
                                'Inclusive of all taxes',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Right Side - Buttons
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              // Add to Cart Button
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: _addToCart,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      side: const BorderSide(
                                        color: Colors.black,
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    child: const Text(
                                      'Add to Cart',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 8),

                              // Buy Now Button
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: _buyNow,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    child: const Text(
                                      'Buy Now',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
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
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildImageCarousel() {
    final images = _product!.images.isNotEmpty
        ? _product!.images
        : ['https://via.placeholder.com/400'];

    return Stack(
      children: [
        // Image PageView
        AspectRatio(
          aspectRatio: 1,
          child: PageView.builder(
            controller: _imageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() => _currentImageIndex = index);
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[100],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.image_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),

        // Zoom Icon Button (Top Right)
        Positioned(
          top: 16,
          right: 16,
          child: GestureDetector(
            onTap: () {
              if (_product!.images.isNotEmpty) {
                ProductImageViewer.show(
                  context,
                  images: _product!.images,
                  initialIndex: _currentImageIndex,
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

        // Page Indicators (Bottom Center)
        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _imageController,
                count: images.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.black,
                  dotColor: Colors.grey,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quantity:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: _decrementQuantity,
                icon: const Icon(Icons.remove, size: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '$_quantity',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: _incrementQuantity,
                icon: const Icon(Icons.add, size: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCollapsibleSection({
    required String title,
    required String content,
  }) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      trailing: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black,
          size: 20,
        ),
      ),
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 16, top: 8),
      children: [
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class ReelsPromoBanner extends StatelessWidget {
  const ReelsPromoBanner({super.key});

  static const _imageUrl =
      'https://www.voyageeyewear.com/cdn/shop/files/NEW_banner_grab150_mob_copy.jpg?v=1742842579&width=800';

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 375 / 503,
      child: CachedNetworkImage(
        imageUrl: _imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        placeholder: (context, url) => Container(
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[200],
          child: const Icon(Icons.error_outline, size: 40, color: Colors.grey),
        ),
      ),
    );
  }
}

class YouMayAlsoLikeSection extends StatelessWidget {
  final List<Product> products;

  const YouMayAlsoLikeSection({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final items = products.take(4).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'You May Also Like',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              final imageUrl = product.images.isNotEmpty
                  ? product.images.first
                  : 'https://via.placeholder.com/300';

              return GestureDetector(
                onTap: () => NavigationHelper.navigateToProduct(
                  context,
                  product.id,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppConstants.formatPrice(product.minPrice),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Show more'),
            ),
          ),
        ],
      ),
    );
  }
}

