import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

import 'avatar.dart';

enum BubbleType {
  top,
  middle,
  bottom,
  alone,
}

enum Direction {
  left,
  right,
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.direction,
    required this.message,
    required this.type,
    this.photoUrl,
  });
  final Direction direction;
  final String message;
  final String? photoUrl;
  final BubbleType type;

  @override
  Widget build(BuildContext context) {
    // Get theme and color scheme
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isOnLeft = direction == Direction.left;

    // Determine bubble background and text color based on direction
    final Color bubbleColor = isOnLeft ? colorScheme.surface : colorScheme.primaryContainer;
    final Color textColor = isOnLeft ? colorScheme.onSurface : colorScheme.onPrimaryContainer;

    // Define Markdown style based on text color
    final MarkdownStyleSheet markdownStyle = MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: theme.textTheme.bodyMedium?.copyWith(color: textColor),
      // Define other styles (h1, code, blockquote, etc.) if needed, inheriting text color
      h1: theme.textTheme.headlineLarge?.copyWith(color: textColor),
      h2: theme.textTheme.headlineMedium?.copyWith(color: textColor),
      h3: theme.textTheme.headlineSmall?.copyWith(color: textColor),
      h4: theme.textTheme.titleLarge?.copyWith(color: textColor),
      h5: theme.textTheme.titleMedium?.copyWith(color: textColor),
      h6: theme.textTheme.titleSmall?.copyWith(color: textColor),
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: const TextStyle(fontWeight: FontWeight.bold),
      code: theme.textTheme.bodyMedium?.copyWith(
        color: textColor.withOpacity(0.8),
        backgroundColor: colorScheme.onSurface.withOpacity(0.05),
        fontFamily: 'monospace',
      ),
      // Add more styles as required
    );

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment:
            isOnLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isOnLeft) _buildLeading(type),
          SizedBox(width: isOnLeft ? 4 : 0),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: _borderRadius(direction, type),
              // Use themed bubble color
              color: bubbleColor,
            ),
            // Apply themed markdown style
            child: MarkdownBody(
              data: message,
              styleSheet: markdownStyle,
              // Ensure selectable text if desired
              selectable: true, 
              onTapLink: (text, href, title) { /* Handle link taps if needed */ },
              // Use appropriate builders if custom markdown elements are needed
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeading(BubbleType type) {
    if (type == BubbleType.alone || type == BubbleType.bottom) {
      return const Avatar(
        radius: 12,
      );
    }
    return const SizedBox(width: 28);
  }

  BorderRadius _borderRadius(Direction dir, BubbleType type) {
    const radius1 = Radius.circular(15);
    const radius2 = Radius.circular(5);
    switch (type) {
      case BubbleType.top:
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius1,
                topRight: radius1,
                bottomLeft: radius2,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius1,
                bottomLeft: radius1,
                bottomRight: radius2,
              );

      case BubbleType.middle:
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius2,
                topRight: radius1,
                bottomLeft: radius2,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius2,
                bottomLeft: radius1,
                bottomRight: radius2,
              );
      case BubbleType.bottom:
        return dir == Direction.left
            ? const BorderRadius.only(
                topLeft: radius2,
                topRight: radius1,
                bottomLeft: radius1,
                bottomRight: radius1,
              )
            : const BorderRadius.only(
                topLeft: radius1,
                topRight: radius2,
                bottomLeft: radius1,
                bottomRight: radius1,
              );
      case BubbleType.alone:
        return BorderRadius.circular(12);
    }
  }
}
