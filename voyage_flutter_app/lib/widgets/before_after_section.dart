import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BeforeAfterSection extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final String beforeImage;
  final String afterImage;
  final String? beforeText;
  final String? afterText;
  final double initialDragPosition;

  const BeforeAfterSection({
    Key? key,
    required this.title,
    this.subtitle,
    this.description,
    required this.beforeImage,
    required this.afterImage,
    this.beforeText = 'Before',
    this.afterText = 'After',
    this.initialDragPosition = 0.5,
  }) : super(key: key);

  @override
  State<BeforeAfterSection> createState() => _BeforeAfterSectionState();
}

class _BeforeAfterSectionState extends State<BeforeAfterSection> {
  late double _dragPosition;

  @override
  void initState() {
    super.initState();
    _dragPosition = widget.initialDragPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          // Title Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                if (widget.subtitle != null)
                  Text(
                    widget.subtitle!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (widget.subtitle != null) const SizedBox(height: 12),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.description != null) const SizedBox(height: 16),
                if (widget.description != null)
                  Text(
                    widget.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Before/After Image Comparison
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        setState(() {
                          _dragPosition = (details.localPosition.dx / constraints.maxWidth)
                              .clamp(0.0, 1.0);
                        });
                      },
                      child: Stack(
                        children: [
                          // After Image (Background - Full Width)
                          Positioned.fill(
                            child: CachedNetworkImage(
                              imageUrl: widget.afterImage,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              ),
                            ),
                          ),
                          
                          // After Text Label
                          if (widget.afterText != null)
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  widget.afterText!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          
                          // Before Image (Clipped to drag position)
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: constraints.maxWidth * _dragPosition,
                            child: ClipRect(
                              child: CachedNetworkImage(
                                imageUrl: widget.beforeImage,
                                fit: BoxFit.cover,
                                width: constraints.maxWidth,
                                alignment: Alignment.centerLeft,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          
                          // Before Text Label
                          if (widget.beforeText != null)
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  widget.beforeText!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          
                          // Divider Line
                          Positioned(
                            left: constraints.maxWidth * _dragPosition - 1,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 2,
                              color: Colors.white,
                            ),
                          ),
                          
                          // Draggable Cursor
                          Positioned(
                            left: constraints.maxWidth * _dragPosition - 20,
                            top: (constraints.maxHeight / 2) - 20,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 2,
                                      height: 16,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 2,
                                      height: 16,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 2,
                                      height: 16,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}

