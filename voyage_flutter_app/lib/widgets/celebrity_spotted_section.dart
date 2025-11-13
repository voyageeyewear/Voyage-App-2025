import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CelebrityItem {
  final String name;
  final String imageUrl;
  final String? url;
  final VoidCallback? onTap;

  const CelebrityItem({
    required this.name,
    required this.imageUrl,
    this.url,
    this.onTap,
  });
}

class CelebritySpottedSection extends StatelessWidget {
  final List<CelebrityItem> celebrities;
  final String title;
  final double imageSize;

  const CelebritySpottedSection({
    Key? key,
    required this.celebrities,
    this.title = 'Celebrity Spotted',
    this.imageSize = 180,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (celebrities.isEmpty) {
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

        // Images - NO BOXES!
        SizedBox(
          height: imageSize,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: celebrities.length,
            itemBuilder: (context, index) {
              final celebrity = celebrities[index];
              
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    if (celebrity.onTap != null) {
                      celebrity.onTap!();
                    } else if (celebrity.url != null) {
                      Navigator.pushNamed(
                        context,
                        '/celebrity',
                        arguments: celebrity.name,
                      );
                    }
                  },
                  // JUST IMAGE - NO WRAPPER AT ALL
                  child: Image.network(
                    celebrity.imageUrl,
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: imageSize,
                        height: imageSize,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox(
                        width: imageSize,
                        height: imageSize,
                      );
                    },
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

