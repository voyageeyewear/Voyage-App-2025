import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ServiceBenefitItem {
  final IconData icon;
  final String title;
  final String description;

  const ServiceBenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class ServiceBenefitsSlider extends StatefulWidget {
  final List<ServiceBenefitItem> benefits;

  const ServiceBenefitsSlider({
    super.key,
    required this.benefits,
  });

  @override
  State<ServiceBenefitsSlider> createState() => _ServiceBenefitsSliderState();
}

class _ServiceBenefitsSliderState extends State<ServiceBenefitsSlider> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.benefits.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          SizedBox(
            height: 260,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.benefits.length,
              itemBuilder: (context, index) {
                final benefit = widget.benefits[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: Icon(
                              benefit.icon,
                              size: 32,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            benefit.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            benefit.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SmoothPageIndicator(
            controller: _controller,
            count: widget.benefits.length,
            effect: const ExpandingDotsEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: Colors.black,
              dotColor: Colors.black26,
              spacing: 6,
            ),
          ),
        ],
      ),
    );
  }
}

