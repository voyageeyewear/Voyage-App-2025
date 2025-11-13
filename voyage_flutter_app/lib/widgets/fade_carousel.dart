import 'package:flutter/material.dart';
import 'dart:async';

class FadeCarouselItem {
  final String imageUrl;
  final VoidCallback? onTap;

  const FadeCarouselItem({
    required this.imageUrl,
    this.onTap,
  });
}

class FadeCarousel extends StatefulWidget {
  final List<FadeCarouselItem> items;
  final double width;
  final double height;
  final Duration duration;
  final Duration fadeDuration;

  const FadeCarousel({
    Key? key,
    required this.items,
    this.width = double.infinity,
    this.height = 500,
    this.duration = const Duration(seconds: 5),
    this.fadeDuration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  @override
  State<FadeCarousel> createState() => _FadeCarouselState();
}

class _FadeCarouselState extends State<FadeCarousel> {
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (widget.items.length > 1) {
      _timer = Timer.periodic(widget.duration, (timer) {
        if (mounted) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % widget.items.length;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          children: [
            // Background images with fade animation
            ...List.generate(widget.items.length, (index) {
              return AnimatedOpacity(
                opacity: _currentIndex == index ? 1.0 : 0.0,
                duration: widget.fadeDuration,
                child: GestureDetector(
                  onTap: widget.items[index].onTap,
                  child: SizedBox(
                    width: widget.width,
                    height: widget.height,
                    child: Image.network(
                      widget.items[index].imageUrl,
                      width: widget.width,
                      height: widget.height,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: widget.width,
                          height: widget.height,
                          color: Colors.grey[200],
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: widget.width,
                          height: widget.height,
                          color: Colors.grey[300],
                        );
                      },
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

