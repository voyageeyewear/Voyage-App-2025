import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  // Show as centered dialog with left-to-right animation
  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: const Color(0x66000000), // Semi-transparent black overlay (40% opacity)
      barrierDismissible: true, // Allow tap outside to close
      barrierLabel: 'Menu',
      transitionDuration: const Duration(milliseconds: 300), // Animation duration
      pageBuilder: (context, animation, secondaryAnimation) {
        return const NavigationDrawerWidget();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Left to right slide animation
        final slideAnimation = Tween<Offset>(
          begin: const Offset(-1.0, 0.0), // Start from left (offscreen)
          end: Offset.zero, // End at center
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ));

        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20), // 20px spacing from all edges
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 600, // Max width for larger screens
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF), // Pure white
          borderRadius: BorderRadius.circular(12), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Center content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close Button
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5), // Light gray
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xFF333333), // Dark gray
                      size: 24,
                    ),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Menu Items (Scrollable if needed)
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMenuItem(
                        context,
                        title: 'SUNGLASSES',
                        hasChevron: true,
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to sunglasses
                        },
                      ),
                      const SizedBox(height: 18),

                      _buildMenuItem(
                        context,
                        title: 'CATEGORIES',
                        hasChevron: true,
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to categories
                        },
                      ),
                      const SizedBox(height: 18),

                      _buildMenuItem(
                        context,
                        title: 'POLARIZED SUNGLASSES',
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to polarized sunglasses
                        },
                      ),
                      const SizedBox(height: 18),

                      _buildMenuItem(
                        context,
                        title: 'OFFERS',
                        isHighlighted: true,
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to offers
                        },
                      ),
                      const SizedBox(height: 18),

                      _buildMenuItem(
                        context,
                        title: 'NEW ARRIVALS',
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to new arrivals
                        },
                      ),
                      const SizedBox(height: 18),

                      _buildMenuItem(
                        context,
                        title: 'RETURN & EXCHANGE',
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to return & exchange
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Footer Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Divider Line
                  Container(
                    height: 1,
                    color: const Color(0xFFE0E0E0),
                  ),

                  const SizedBox(height: 24),

                  // "Let's Connect On" heading
                  const Text(
                    "Let's Connect On",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Social Media Icons
                  Row(
                    children: [
                      _buildSocialIcon(
                        Icons.facebook,
                        onTap: () {
                          // Open Facebook
                        },
                      ),
                      const SizedBox(width: 24),
                      _buildSocialIcon(
                        Icons.camera_alt_outlined, // Instagram
                        onTap: () {
                          // Open Instagram
                        },
                      ),
                      const SizedBox(width: 24),
                      _buildSocialIcon(
                        Icons.business_center_outlined, // LinkedIn
                        onTap: () {
                          // Open LinkedIn
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Divider Line
                  Container(
                    height: 1,
                    color: const Color(0xFFE0E0E0),
                  ),

                  const SizedBox(height: 20),

                  // Log in Link
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to login
                    },
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF000000),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    bool hasChevron = false,
    bool isHighlighted = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.grey.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: isHighlighted
                    ? const Color(0xFFFFA500) // Bright orange for OFFERS
                    : const Color(0xFF000000), // Black for regular items
                letterSpacing: 1.0,
                height: 1.4, // Line height
                fontFamily: 'sans-serif',
              ),
            ),
          ),
          if (hasChevron)
            const Icon(
              Icons.chevron_right,
              color: Color(0xFFD3D3D3), // Light gray chevron
              size: 24,
            ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Icon(
        icon,
        size: 20,
        color: const Color(0xFF000000), // Black icons
      ),
    );
  }
}
