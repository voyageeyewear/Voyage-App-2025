import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/announcement_bar.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/search_drawer.dart';
import '../widgets/hero_carousel.dart';
import '../widgets/shop_by_shape_carousel.dart';
import '../widgets/quick_picks_section.dart';
import '../widgets/celebrity_spotted_section.dart';
import '../widgets/fade_carousel.dart';
import '../widgets/new_launched_section.dart';
import '../widgets/as_featured_section.dart';
import '../widgets/best_selling_section.dart';
import '../widgets/before_after_section.dart';
import '../widgets/featured_product_section.dart';
import '../widgets/faq_section.dart';
import '../widgets/service_benefits_slider.dart';
import '../widgets/footer_section.dart';
import '../config/announcement_config.dart';
import '../config/shop_by_shape_config.dart';
import '../config/celebrity_config.dart';
import '../config/fade_carousel_config.dart';
import '../config/featured_config.dart';
import '../config/before_after_config.dart';
import '../config/faq_config.dart';
import '../config/service_benefits_config.dart';
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
                      icon: const Icon(Icons.menu, size: 24, color: Colors.black),
                      onPressed: () {
                        NavigationDrawerWidget.show(context);
                      },
                      padding: EdgeInsets.zero,
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, size: 24, color: Colors.black),
                      onPressed: () => SearchDrawerWidget.show(context),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                leadingWidth: 100,
                title: Image.network(
                  'https://www.voyageeyewear.com/cdn/shop/files/Voyage_hindi_2.png?v=1720597430&width=350',
                  height: 26,
                  fit: BoxFit.contain,
                ),
                centerTitle: true,
                actions: [
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

                        // Celebrity Spotted Section
                        if (CelebrityConfig.enabled)
                          SliverToBoxAdapter(
                            child: CelebritySpottedSection(
                              celebrities: CelebrityConfig.celebrities,
                              title: CelebrityConfig.sectionTitle,
                              imageSize: CelebrityConfig.imageSize,
                            ),
                          ),

                        // Fade Carousel Section (1400×500)
                        if (FadeCarouselConfig.enabled)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                              child: FadeCarousel(
                                items: FadeCarouselConfig.items,
                                width: FadeCarouselConfig.width,
                                height: FadeCarouselConfig.height,
                                duration: FadeCarouselConfig.duration,
                                fadeDuration: FadeCarouselConfig.fadeDuration,
                              ),
                            ),
                          ),

                        // New Launched Section
                        SliverToBoxAdapter(
                          child: NewLaunchedSection(
                            products: productProvider.products.take(10).toList(),
                            title: 'New Launched',
                            onViewAll: () {
                              // Navigate to all products
                            },
                          ),
                        ),

                        // As Featured On Section
                        if (FeaturedConfig.enabled)
                          SliverToBoxAdapter(
                            child: AsFeaturedSection(
                              logos: FeaturedConfig.logos,
                              title: FeaturedConfig.sectionTitle,
                            ),
                          ),

                        // Best Selling Section
                        SliverToBoxAdapter(
                          child: BestSellingSection(
                            products: productProvider.products.skip(4).take(6).toList(),
                            title: 'Best Selling',
                            onViewAll: () {
                              // Navigate to all products
                            },
                          ),
                        ),

                        // Before/After Section
                        if (BeforeAfterConfig.enabled)
                          const SliverToBoxAdapter(
                            child: BeforeAfterSection(
                              title: BeforeAfterConfig.title,
                              subtitle: BeforeAfterConfig.subtitle,
                              description: BeforeAfterConfig.description,
                              beforeImage: BeforeAfterConfig.beforeImage,
                              afterImage: BeforeAfterConfig.afterImage,
                              beforeText: BeforeAfterConfig.beforeText,
                              afterText: BeforeAfterConfig.afterText,
                              initialDragPosition: BeforeAfterConfig.initialDragPosition,
                            ),
                          ),

                        // Featured Product Section
                        if (productProvider.products.isNotEmpty)
                          SliverToBoxAdapter(
                            child: FeaturedProductSection(
                              product: productProvider.products.firstWhere(
                                (p) => p.title.toLowerCase().contains('aurix'),
                                orElse: () => productProvider.products.first,
                              ),
                            ),
                          ),

                        // FAQ Section
                        if (FaqConfig.enabled)
                          const SliverToBoxAdapter(
                            child: FaqSection(
                              faqs: FaqConfig.faqs,
                              introText: FaqConfig.introText,
                              footerText: FaqConfig.footerText,
                            ),
                          ),

                        // Service Benefits Slider
                        if (ServiceBenefitsConfig.enabled)
                          const SliverToBoxAdapter(
                            child: ServiceBenefitsSlider(
                              benefits: ServiceBenefitsConfig.benefits,
                            ),
                          ),

                        // Footer Section
                        const SliverToBoxAdapter(
                          child: FooterSection(),
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

