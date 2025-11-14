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

    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          SizedBox(
            height: 280,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.benefits.length,
              itemBuilder: (context, index) {
                final benefit = widget.benefits[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, 10),
                        ),
                      ],
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
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: Icon(
                              benefit.icon,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 18),
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
                              height: 1.5,
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
              activeDotColor: Color(0xFF0057FF),
              dotColor: Color(0xFFBFC3C8),
              spacing: 6,
            ),
          ),
        ],
      ),
    );
  }
}

