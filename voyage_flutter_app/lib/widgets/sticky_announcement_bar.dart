import 'package:flutter/material.dart';
import 'announcement_bar.dart';

/// A sticky announcement bar that stays at the top when scrolling
class StickyAnnouncementBar extends StatelessWidget {
  final List<AnnouncementMessage> messages;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final bool autoScroll;
  final Duration scrollDuration;

  const StickyAnnouncementBar({
    Key? key,
    required this.messages,
    this.backgroundColor,
    this.textColor,
    this.height = 45.0,
    this.autoScroll = true,
    this.scrollDuration = const Duration(seconds: 5),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Material(
      elevation: 2,
      child: AnnouncementBar(
        messages: messages,
        backgroundColor: backgroundColor,
        textColor: textColor,
        height: height,
        autoScroll: autoScroll,
        scrollDuration: scrollDuration,
      ),
    );
  }
}

