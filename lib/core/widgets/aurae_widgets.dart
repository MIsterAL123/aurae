import 'dart:math' as math;
import 'dart:io';

import 'package:flutter/material.dart';

import '../../app/aurae_theme.dart';

class AuraeBrand extends StatelessWidget {
  const AuraeBrand({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(size: Size.square(compact ? 28 : 42), painter: _Mark()),
        const SizedBox(width: 10),
        Text(
          'AURAE',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            letterSpacing: compact ? 3 : 5,
            fontSize: compact ? 18 : 25,
          ),
        ),
      ],
    );
  }
}

class _Mark extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AuraeColors.espresso
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * .2;
    canvas.drawCircle(center, radius, paint);
    for (var i = 0; i < 8; i++) {
      final angle = i * 3.1415926535 / 4;
      final start = Offset(
        center.dx + radius * .7 * math.cos(angle),
        center.dy + radius * .7 * math.sin(angle),
      );
      final end = Offset(
        center.dx + size.width * .43 * math.cos(angle),
        center.dy + size.height * .43 * math.sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FashionImage extends StatelessWidget {
  const FashionImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.borderRadius = 16,
  });

  final String url;
  final BoxFit fit;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: const ColoredBox(
          color: AuraeColors.surfaceContainer,
          child: Center(
            child: Icon(
              Icons.checkroom_outlined,
              size: 40,
              color: AuraeColors.muted,
            ),
          ),
        ),
      );
    }

    if (url.startsWith('file://')) {
      final file = File(Uri.parse(url).toFilePath());
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: ColoredBox(
          color: AuraeColors.surfaceContainer,
          child: Image.file(
            file,
            fit: fit,
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(
                Icons.broken_image_outlined,
                size: 40,
                color: AuraeColors.muted,
              ),
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ColoredBox(
        color: AuraeColors.surfaceContainer,
        child: Image.network(
          url,
          fit: fit,
          frameBuilder: (context, child, frame, _) => AnimatedOpacity(
            opacity: frame == null ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: child,
          ),
          loadingBuilder: (context, child, progress) => progress == null
              ? child
              : const Center(
                  child: CircularProgressIndicator(strokeWidth: 1.5),
                ),
          errorBuilder: (_, __, ___) => const Center(
            child: Icon(
              Icons.checkroom_outlined,
              size: 40,
              color: AuraeColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
        ),
        if (action != null)
          TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 52, color: AuraeColors.muted),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
