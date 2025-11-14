import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeaturedLogoItem {
  final String imageUrl;
  final String name;
  final VoidCallback? onTap;

  const FeaturedLogoItem({
    required this.imageUrl,
    required this.name,
    this.onTap,
  });
}

class AsFeaturedSection extends StatelessWidget {
  final List<FeaturedLogoItem> logos;
  final String title;

  const AsFeaturedSection({
    Key? key,
    required this.logos,
    this.title = 'As Featured On',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (logos.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Logos Horizontal Scroller
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: logos.length,
              itemBuilder: (context, index) {
                return _buildLogo(context, logos[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context, FeaturedLogoItem logo) {
    return GestureDetector(
      onTap: logo.onTap,
      child: Container(
        width: 160,
        height: 100,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CachedNetworkImage(
          imageUrl: logo.imageUrl,
          fit: BoxFit.contain,
          placeholder: (context, url) => Container(
            color: Colors.grey[50],
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[50],
            child: Center(
              child: Icon(
                Icons.image_outlined,
                color: Colors.grey[400],
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

