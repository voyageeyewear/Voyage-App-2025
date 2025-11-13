import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShapeItem {
  final String title;
  final String imageUrl;
  final String? collectionHandle; // For navigation
  final VoidCallback? onTap;

  const ShapeItem({
    required this.title,
    required this.imageUrl,
    this.collectionHandle,
    this.onTap,
  });
}

class ShopByShapeCarousel extends StatelessWidget {
  final List<ShapeItem> items;
  final String title;
  final double itemWidth;
  final double itemHeight;

  const ShopByShapeCarousel({
    Key? key,
    required this.items,
    this.title = 'Shop By Shape',
    this.itemWidth = 180,
    this.itemHeight = 210,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        // Horizontal Carousel
        SizedBox(
          height: itemHeight, // No extra space needed since no text below
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () {
                  if (item.onTap != null) {
                    item.onTap!();
                  } else if (item.collectionHandle != null) {
                    // Navigate to collection page
                    Navigator.pushNamed(
                      context,
                      '/collection',
                      arguments: item.collectionHandle,
                    );
                  }
                },
                child: Container(
                  width: itemWidth,
                  margin: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: itemWidth,
                      height: itemHeight,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.image_outlined,
                              color: Colors.grey[500],
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

