import 'package:flutter/material.dart';

class SearchDrawerWidget extends StatelessWidget {
  const SearchDrawerWidget({Key? key}) : super(key: key);

  // Show search drawer with top-to-bottom shutter animation
  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierColor: const Color(0x66000000), // Semi-transparent overlay
      barrierDismissible: true,
      barrierLabel: 'Search',
      transitionDuration: const Duration(milliseconds: 400), // Shutter animation duration
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SearchDrawerWidget();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        // Top to bottom slide animation (shutter effect)
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, -1.0), // Start from top (offscreen)
          end: Offset.zero, // End at normal position
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
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 20), // Space from top
        constraints: const BoxConstraints(
          maxWidth: 600, // Max width for larger screens
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF), // Pure white
          borderRadius: BorderRadius.circular(16), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search Bar Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  // Search Input
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF999999),
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Search for...',
                        hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF999999),
                        ),
                      ),
                      onChanged: (value) {
                        // Handle search
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Close Button
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Divider
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: const Color(0xFFE0E0E0),
            ),

            const SizedBox(height: 24),

            // Menu Items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMenuItem(
                    context,
                    title: 'SUNGLASSES',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to sunglasses
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildMenuItem(
                    context,
                    title: 'CATEGORIES',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to categories
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildMenuItem(
                    context,
                    title: 'POLARIZED SUNGLASSES',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to polarized sunglasses
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildMenuItem(
                    context,
                    title: 'OFFERS',
                    isHighlighted: true,
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to offers
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildMenuItem(
                    context,
                    title: 'NEW ARRIVALS',
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to new arrivals
                    },
                  ),
                  const SizedBox(height: 20),

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

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    bool isHighlighted = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: isHighlighted
              ? const Color(0xFFFFA500) // Bright orange for OFFERS
              : const Color(0xFF000000), // Black for regular items
          letterSpacing: 0.5,
          height: 1.3,
        ),
      ),
    );
  }
}
