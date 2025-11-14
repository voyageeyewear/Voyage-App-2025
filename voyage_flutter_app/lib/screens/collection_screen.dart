import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../models/product.dart';
import '../utils/navigation_helper.dart';
import '../widgets/announcement_bar.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/search_drawer.dart';
import '../config/announcement_config.dart';
import '../utils/constants.dart';

class CollectionScreen extends StatefulWidget {
  final String collectionHandle;

  const CollectionScreen({
    super.key,
    required this.collectionHandle,
  });

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  int _visibleCount = 50;

  SortOption _sortOption = SortOption.featured;
  bool _inStockOnly = false;
  RangeValues _priceBounds = const RangeValues(0, 5000);
  RangeValues _selectedPriceRange = const RangeValues(0, 5000);

  bool _initializing = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await context
          .read<ProductProvider>()
          .fetchCollectionProducts(widget.collectionHandle);

      final minPrice = products.isNotEmpty
          ? products.map((p) => p.minPrice).reduce(min)
          : 0;
      final maxPrice = products.isNotEmpty
          ? products.map((p) => p.minPrice).reduce(max)
          : 5000;

      setState(() {
        _allProducts = products;
        _priceBounds = RangeValues(minPrice.floorToDouble(),
            max(maxPrice.ceilToDouble(), minPrice.floorToDouble() + 1));
        _selectedPriceRange = _priceBounds;
        _initializing = false;
      });

      _applyFilters();
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

  void _applyFilters() {
    List<Product> filtered = List.from(_allProducts);

    if (_inStockOnly) {
      filtered = filtered.where((p) => p.availableForSale).toList();
    }

    filtered = filtered
        .where((p) =>
            p.minPrice >= _selectedPriceRange.start &&
            p.minPrice <= _selectedPriceRange.end)
        .toList();

    filtered = _sortProducts(filtered);

    setState(() {
      _filteredProducts = filtered;
      _visibleCount = min(50, _filteredProducts.length);
    });
  }

  List<Product> _sortProducts(List<Product> products) {
    final sorted = List<Product>.from(products);
    switch (_sortOption) {
      case SortOption.featured:
        return sorted;
      case SortOption.bestSelling:
        return sorted;
      case SortOption.alphaAZ:
        sorted.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        return sorted;
      case SortOption.alphaZA:
        sorted.sort(
            (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        return sorted;
      case SortOption.priceLowHigh:
        sorted.sort((a, b) => a.minPrice.compareTo(b.minPrice));
        return sorted;
      case SortOption.priceHighLow:
        sorted.sort((a, b) => b.minPrice.compareTo(a.minPrice));
        return sorted;
      case SortOption.dateOldNew:
        sorted.sort((a, b) => a.id.compareTo(b.id));
        return sorted;
      case SortOption.dateNewOld:
        sorted.sort((a, b) => b.id.compareTo(a.id));
        return sorted;
    }
  }

  void _loadMore() {
    setState(() {
      _visibleCount = min(_visibleCount + 50, _filteredProducts.length);
    });
  }

  int get _activeFilterCount {
    int count = 0;
    if (_sortOption != SortOption.featured) count++;
    if (_inStockOnly) count++;
    if (_selectedPriceRange != _priceBounds) count++;
    return count;
  }

  Future<void> _openFilterSheet() async {
    final result = await showModalBottomSheet<_FilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSheet(
        sortOption: _sortOption,
        inStockOnly: _inStockOnly,
        priceBounds: _priceBounds,
        selectedRange: _selectedPriceRange,
        activeFilters: _activeFilterCount,
      ),
    );

    if (result != null) {
      setState(() {
        _sortOption = result.sortOption;
        _inStockOnly = result.inStockOnly;
        _selectedPriceRange = result.priceRange;
      });
      _applyFilters();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final isLoading = productProvider.isLoading && _initializing;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(
            kToolbarHeight + AnnouncementConfig.barHeight,
          ),
          child: Column(
            children: [
              if (AnnouncementConfig.enabled)
                AnnouncementBar(
                  messages: AnnouncementConfig.messages,
                  backgroundColor: AppConstants.primaryColor,
                  textColor: Colors.white,
                  height: AnnouncementConfig.barHeight,
                  scrollSpeed: AnnouncementConfig.scrollSpeed,
                ),
              AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.menu, size: 24, color: Colors.black),
                  onPressed: () => NavigationDrawerWidget.show(context),
                ),
                title: Image.network(
                  'https://www.voyageeyewear.com/cdn/shop/files/Voyage_hindi_2.png?v=1720597430&width=350',
                  height: 26,
                  fit: BoxFit.contain,
                ),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () => SearchDrawerWidget.show(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined,
                        color: Colors.black),
                    onPressed: () => NavigationHelper.navigateToCart(context),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_filteredProducts.isEmpty)
              const Center(child: Text('No products found'))
            else
              RefreshIndicator(
                onRefresh: _loadProducts,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_filteredProducts.length} products',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.collectionHandle
                                  .replaceAll('-', ' ')
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = _filteredProducts[index];
                            return CollectionProductCard(product: product);
                          },
                          childCount: _visibleCount,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.62,
                        ),
                      ),
                    ),
                    if (_visibleCount < _filteredProducts.length)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 24,
                          ),
                          child: OutlinedButton(
                            onPressed: _loadMore,
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text('Load more'),
                          ),
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 80)),
                  ],
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Center(
                child: GestureDetector(
                  onTap: _openFilterSheet,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.tune, color: Colors.white),
                        SizedBox(width: 12),
                        Text(
                          'Filter and sort',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CollectionProductCard extends StatelessWidget {
  final Product product;

  const CollectionProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final compare =
        product.compareAtPrice != null ? double.tryParse(product.compareAtPrice!) : null;
    final savings = (compare != null && compare > product.minPrice)
        ? compare - product.minPrice
        : null;

    return GestureDetector(
      onTap: () => NavigationHelper.navigateToProduct(context, product.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    product.images.isNotEmpty
                        ? product.images.first
                        : 'https://via.placeholder.com/400',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                if (savings != null)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1f5ad7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Save Rs. ${savings.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.shopping_bag_outlined),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Rs. ${product.minPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (compare != null && compare > product.minPrice)
            Text(
              'Rs. ${compare.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                decoration: TextDecoration.lineThrough,
              ),
            ),
        ],
      ),
    );
  }
}

class FilterSheet extends StatefulWidget {
  final SortOption sortOption;
  final bool inStockOnly;
  final RangeValues priceBounds;
  final RangeValues selectedRange;
  final int activeFilters;

  const FilterSheet({
    super.key,
    required this.sortOption,
    required this.inStockOnly,
    required this.priceBounds,
    required this.selectedRange,
    required this.activeFilters,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late SortOption _sortOption;
  late bool _inStockOnly;
  late RangeValues _priceRange;
  late TextEditingController _minController;
  late TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    _sortOption = widget.sortOption;
    _inStockOnly = widget.inStockOnly;
    _priceRange = widget.selectedRange;
    _minController =
        TextEditingController(text: widget.selectedRange.start.toStringAsFixed(0));
    _maxController =
        TextEditingController(text: widget.selectedRange.end.toStringAsFixed(0));
  }

  void _updateRange(RangeValues values) {
    setState(() {
      _priceRange = values;
      _minController.text = values.start.toStringAsFixed(0);
      _maxController.text = values.end.toStringAsFixed(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    const Text(
                      'Sort by',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...SortOption.values.map(
                      (option) => CheckboxListTile(
                        value: _sortOption == option,
                        onChanged: (_) {
                          setState(() => _sortOption = option);
                        },
                        title: Text(option.label),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    const Divider(height: 32),
                    SwitchListTile(
                      value: _inStockOnly,
                      onChanged: (value) {
                        setState(() => _inStockOnly = value);
                      },
                      title: const Text(
                        'In stock only',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Divider(height: 32),
                    const Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    RangeSlider(
                      min: widget.priceBounds.start,
                      max: widget.priceBounds.end,
                      values: _priceRange,
                      onChanged: _updateRange,
                      activeColor: Colors.black,
                      inactiveColor: Colors.black26,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _PriceInputField(
                            label: '₹',
                            controller: _minController,
                            onSubmitted: (value) {
                              final parsed = double.tryParse(value) ??
                                  widget.priceBounds.start;
                              _updateRange(RangeValues(
                                parsed.clamp(widget.priceBounds.start,
                                    widget.priceBounds.end),
                                _priceRange.end,
                              ));
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _PriceInputField(
                            label: '₹',
                            controller: _maxController,
                            onSubmitted: (value) {
                              final parsed = double.tryParse(value) ??
                                  widget.priceBounds.end;
                              _updateRange(RangeValues(
                                _priceRange.start,
                                parsed.clamp(widget.priceBounds.start,
                                    widget.priceBounds.end),
                              ));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      _FilterResult(
                        sortOption: _sortOption,
                        inStockOnly: _inStockOnly,
                        priceRange: _priceRange,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Text('Apply (${widget.activeFilters})'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PriceInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const _PriceInputField({
    required this.label,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      onSubmitted: onSubmitted,
    );
  }
}

class _FilterResult {
  final SortOption sortOption;
  final bool inStockOnly;
  final RangeValues priceRange;

  _FilterResult({
    required this.sortOption,
    required this.inStockOnly,
    required this.priceRange,
  });
}

enum SortOption {
  featured,
  bestSelling,
  alphaAZ,
  alphaZA,
  priceLowHigh,
  priceHighLow,
  dateOldNew,
  dateNewOld,
}

extension SortOptionLabel on SortOption {
  String get label {
    switch (this) {
      case SortOption.featured:
        return 'Featured';
      case SortOption.bestSelling:
        return 'Best selling';
      case SortOption.alphaAZ:
        return 'Alphabetically, A-Z';
      case SortOption.alphaZA:
        return 'Alphabetically, Z-A';
      case SortOption.priceLowHigh:
        return 'Price, low to high';
      case SortOption.priceHighLow:
        return 'Price, high to low';
      case SortOption.dateOldNew:
        return 'Date, old to new';
      case SortOption.dateNewOld:
        return 'Date, new to old';
    }
  }
}
