import 'package:flutter/material.dart';

class AnnouncementBar extends StatefulWidget {
  final List<AnnouncementMessage> messages;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double scrollSpeed;
  final TextStyle? textStyle;

  const AnnouncementBar({
    Key? key,
    required this.messages,
    this.backgroundColor,
    this.textColor,
    this.height = 38.0,
    this.scrollSpeed = 30.0, // pixels per second
    this.textStyle,
  }) : super(key: key);

  @override
  State<AnnouncementBar> createState() => _AnnouncementBarState();
}

class _AnnouncementBarState extends State<AnnouncementBar>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Calculate duration based on content and speed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final duration = Duration(seconds: (maxScroll / widget.scrollSpeed).round());
        
        _animationController = AnimationController(
          vsync: this,
          duration: duration,
        );

        _animationController.addListener(() {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(
              _animationController.value * _scrollController.position.maxScrollExtent,
            );
          }
        });

        _animationController.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _animationController.reset();
            _animationController.forward();
          }
        });

        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (_animationController.isAnimating) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.messages.isEmpty) {
      return const SizedBox.shrink();
    }

    final backgroundColor = widget.backgroundColor ?? Theme.of(context).primaryColor;
    final textColor = widget.textColor ?? Colors.white;

    return Container(
      height: widget.height,
      color: backgroundColor,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.messages.length * 100, // Repeat messages
        itemBuilder: (context, index) {
          final message = widget.messages[index % widget.messages.length];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.icon != null) ...[
                    Icon(message.icon, color: textColor, size: 16),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    message.text,
                    style: widget.textStyle ??
                        TextStyle(
                          color: textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.fiber_manual_record, color: textColor, size: 6),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class AnnouncementMessage {
  final String text;
  final IconData? icon;
  final VoidCallback? onTap;

  const AnnouncementMessage({
    required this.text,
    this.icon,
    this.onTap,
  });
}
