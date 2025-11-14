import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterLink {
  final String title;
  final VoidCallback? onTap;
  final String? url;

  const FooterLink({
    required this.title,
    this.onTap,
    this.url,
  });
}

class FooterSection extends StatelessWidget {
  const FooterSection({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Footer Content (4 columns in 2 rows on mobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Services & Information
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Services Column
                  Expanded(
                    child: _buildFooterColumn(
                      title: 'Services',
                      links: [
                        FooterLink(
                          title: 'Frame Guide',
                          onTap: () {},
                        ),
                        FooterLink(
                          title: 'Track Your Order ✈️',
                          onTap: () {},
                        ),
                        FooterLink(
                          title: 'Note to customer',
                          onTap: () {},
                        ),
                        FooterLink(
                          title: 'Contact Us',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 24),

                  // Information Column
                  Expanded(
                    child: _buildFooterColumn(
                      title: 'Information',
                      links: [
                        FooterLink(
                          title: 'Privacy policy',
                          onTap: () {},
                        ),
                        FooterLink(
                          title: 'Terms & Conditions',
                          onTap: () {},
                        ),
                        FooterLink(
                          title: 'Delivery & shipping',
                          onTap: () {},
                        ),
                        FooterLink(
                          title: 'Return Refunds &\nExchange Policies',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Row 2: Contact us & About Voyage Eyewear
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact us Column
                  Expanded(
                    child: _buildFooterColumn(
                      title: 'Contact us',
                      links: [
                        FooterLink(
                          title: 'Email us',
                          onTap: () => _launchUrl('mailto:support@voyageeyewear.in'),
                        ),
                        FooterLink(
                          title: 'Return/Exchange\nCenter',
                          onTap: () {},
                        ),
                        FooterLink(
                          title: 'Whatsapp',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 24),

                  // About Voyage Eyewear Column
                  Expanded(
                    child: _buildFooterColumn(
                      title: 'About Voyage\nEyewear',
                      links: [
                        FooterLink(
                          title: 'About Us',
                          onTap: () {},
                        ),
                        FooterLink(
                          title: 'Blog',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Social Media Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Let\'s Connect On',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildSocialIcon(
                    icon: Icons.facebook,
                    onTap: () => _launchUrl('https://facebook.com/voyageeyewear'),
                  ),
                  const SizedBox(width: 20),
                  _buildSocialIcon(
                    icon: Icons.camera_alt,
                    onTap: () => _launchUrl('https://instagram.com/voyageeyewear'),
                  ),
                  const SizedBox(width: 20),
                  _buildSocialIcon(
                    icon: Icons.business_center,
                    onTap: () => _launchUrl('https://linkedin.com/company/voyageeyewear'),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Country/Currency Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[700]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Text(
                      '🇮🇳',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'India (INR ₹)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Copyright
          Text(
            '© 2025, Voyage Eyewear - A Unit of SS Enterprises',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterColumn({
    required String title,
    required List<FooterLink> links,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column Title
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 16),
        // Links
        ...links.map((link) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: link.onTap,
              child: Text(
                link.title,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[400],
                  height: 1.4,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[700]!),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

