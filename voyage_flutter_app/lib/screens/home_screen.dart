import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/announcement_bar.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/search_drawer.dart';
import '../widgets/hero_carousel.dart';
import '../widgets/shop_by_shape_carousel.dart';
import '../widgets/quick_picks_section.dart';
import '../config/announcement_config.dart';
import '../config/shop_by_shape_config.dart';
import '../utils/navigation_helper.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final productProvider = context.read<ProductProvider>();
    try {
      await productProvider.fetchProducts(limit: 20);
      await productProvider.fetchCollections();
    } catch (e) {
      if (mounted) {
        NavigationHelper.showSnackBar(
          context,
          'Failed to load products: $e',
          isError: true,
        );
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 38.0),
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
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, size: 24),
                      onPressed: () {
                        NavigationDrawerWidget.show(context);
                      },
                      padding: EdgeInsets.zero,
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, size: 24),
                      onPressed: () => SearchDrawerWidget.show(context),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                leadingWidth: 100,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'voyage',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '|',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'वॉयेज',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
                actions: [
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined, size: 24),
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
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          if (productProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (productProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${productProvider.error}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: CustomScrollView(
                      slivers: [
                        // Hero Carousel (800x1067)
                        SliverToBoxAdapter(
                          child: HeroCarousel(
                            items: const [
                              CarouselItem(
                                imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/phone_size.jpg?v=1757661560&width=800',
                              ),
                              CarouselItem(
                                imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/phone_size.jpg?v=1757661560&width=800',
                              ),
                              CarouselItem(
                                imageUrl: 'https://www.voyageeyewear.com/cdn/shop/files/phone_size.jpg?v=1757661560&width=800',
                              ),
                            ],
                          ),
                        ),

                        // Shop By Shape Section
                        if (ShopByShapeConfig.enabled)
                          SliverToBoxAdapter(
                            child: ShopByShapeCarousel(
                              items: ShopByShapeConfig.shapes,
                              title: ShopByShapeConfig.sectionTitle,
                              itemWidth: ShopByShapeConfig.itemWidth,
                              itemHeight: ShopByShapeConfig.itemHeight,
                            ),
                          ),

                        // Quick Picks Section
                        SliverToBoxAdapter(
                          child: QuickPicksSection(
                            products: productProvider.products.take(10).toList(),
                            title: 'Quick Picks',
                            onViewAll: () {
                              // Navigate to all products
                            },
                          ),
                        ),

                // Collections Section
                if (productProvider.collections.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Shop by Category',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: productProvider.collections.length,
                        itemBuilder: (context, index) {
                          final collection = productProvider.collections[index];
                          return GestureDetector(
                            onTap: () {
                              NavigationHelper.navigateToCollection(
                                context,
                                collection.handle,
                              );
                            },
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 16),
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: AppConstants.primaryColor.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.category,
                                      size: 40,
                                      color: AppConstants.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    collection.title,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],

                // Products Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Featured Products',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ),

                if (productProvider.products.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text('No products available'),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = productProvider.products[index];
                          return ProductCard(product: product);
                        },
                        childCount: productProvider.products.length,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            ),
          );
        },
      ),
      ),
    );
  }
}

