import 'package:flutter/material.dart';

class FaqItem {
  final String question;
  final String answer;
  final List<String>? bulletPoints;

  const FaqItem({
    required this.question,
    required this.answer,
    this.bulletPoints,
  });
}

class FaqSection extends StatefulWidget {
  final List<FaqItem> faqs;
  final String? introText;
  final String? footerText;

  const FaqSection({
    Key? key,
    required this.faqs,
    this.introText,
    this.footerText,
  }) : super(key: key);

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  int? _expandedIndex;

  void _toggleExpansion(int index) {
    setState(() {
      if (_expandedIndex == index) {
        _expandedIndex = null;
      } else {
        _expandedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 24),

          // Intro Text
          if (widget.introText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Text(
                widget.introText!,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  height: 1.6,
                ),
              ),
            ),

          // FAQ Items Container
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: List.generate(widget.faqs.length, (index) {
                final faq = widget.faqs[index];
                final isExpanded = _expandedIndex == index;

                return Column(
                  children: [
                    // Question Row
                    InkWell(
                      onTap: () => _toggleExpansion(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                faq.question,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isExpanded
                                    ? Colors.black
                                    : Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: isExpanded
                                    ? Colors.white
                                    : Colors.grey[700],
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Answer (Expandable)
                    if (isExpanded)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main answer text
                            if (faq.answer.isNotEmpty)
                              Text(
                                faq.answer,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[800],
                                  height: 1.6,
                                ),
                              ),

                            // Bullet points (if any)
                            if (faq.bulletPoints != null &&
                                faq.bulletPoints!.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              ...faq.bulletPoints!.map((point) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          size: 16,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          point,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[800],
                                            height: 1.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ],
                        ),
                      ),

                    // Divider (except for last item)
                    if (index < widget.faqs.length - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Divider(
                          color: Colors.grey[300],
                          thickness: 1,
                          height: 1,
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),

          // Footer Text
          if (widget.footerText != null) ...[
            const SizedBox(height: 32),
            Center(
              child: Text(
                widget.footerText!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.6,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

