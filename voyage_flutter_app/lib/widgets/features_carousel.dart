import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

class FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  const FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class FeaturesCarousel extends StatefulWidget {
  final List<FeatureItem> features;
  final Duration autoPlayDuration;

  const FeaturesCarousel({
    Key? key,
    required this.features,
    this.autoPlayDuration = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  State<FeaturesCarousel> createState() => _FeaturesCarouselState();
}

class _FeaturesCarouselState extends State<FeaturesCarousel> {
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (widget.features.length > 1) {
      _timer = Timer.periodic(widget.autoPlayDuration, (timer) {
        if (_pageController.hasClients) {
          int nextPage = (_pageController.page?.round() ?? 0) + 1;
          if (nextPage >= widget.features.length) {
            nextPage = 0;
          }
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          // Carousel
          SizedBox(
            height: 380,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.features.length,
              onPageChanged: (index) {
                setState(() {
                  _startAutoPlay(); // Reset timer on manual swipe
                });
              },
              itemBuilder: (context, index) {
                final feature = widget.features[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          feature.icon,
                          size: 40,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        feature.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Description
                      Text(
                        feature.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Dot Indicators
          if (widget.features.length > 1)
            SmoothPageIndicator(
              controller: _pageController,
              count: widget.features.length,
              effect: WormEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: Colors.black,
                dotColor: Colors.grey[400]!,
                spacing: 12,
              ),
            ),
        ],
      ),
    );
  }
}

