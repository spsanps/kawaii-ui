import 'dart:math';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII CIRCULAR PROGRESS — animated ring with optional label
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiCircularProgress extends StatefulWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color color;
  final Color? trackColor;
  final bool showLabel;
  final TextStyle? labelStyle;
  final bool animate;
  final Duration animationDuration;
  final Widget? child;

  const KawaiiCircularProgress({
    super.key,
    required this.progress,
    this.size = 60,
    this.strokeWidth = 6,
    required this.color,
    this.trackColor,
    this.showLabel = true,
    this.labelStyle,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 800),
    this.child,
  });

  @override
  State<KawaiiCircularProgress> createState() =>
      _KawaiiCircularProgressState();
}

class _KawaiiCircularProgressState extends State<KawaiiCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: KawaiiCurves.soft,
    ));

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(KawaiiCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.progress.clamp(0.0, 1.0),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: KawaiiCurves.soft,
      ));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trackColor =
        widget.trackColor ?? KawaiiColors.pinkTop.withValues(alpha: 0.25);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final currentProgress = _progressAnimation.value;
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              RepaintBoundary(
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _CircularProgressPainter(
                    progress: currentProgress,
                    strokeWidth: widget.strokeWidth,
                    color: widget.color,
                    trackColor: trackColor,
                  ),
                ),
              ),
              if (widget.child != null)
                widget.child!
              else if (widget.showLabel)
                Text(
                  '${(currentProgress * 100).round()}%',
                  style: widget.labelStyle ??
                      kHeading(
                        size: widget.size * 0.22,
                        color: widget.color,
                      ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final Color trackColor;

  const _CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Foreground arc
    if (progress > 0) {
      // Glow shadow when progress >= 1.0
      if (progress >= 1.0) {
        final glowPaint = Paint()
          ..color = color.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + 4
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
        canvas.drawArc(
          rect,
          -pi / 2,
          2 * pi * progress,
          false,
          glowPaint,
        );
      }

      final arcPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        rect,
        -pi / 2,
        2 * pi * progress,
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.strokeWidth != strokeWidth;
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
//  KAWAII CHIP — selectable / deletable tag chip
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class KawaiiChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final VoidCallback? onDeleted;
  final Color color;
  final Widget? avatar;

  const KawaiiChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.onDeleted,
    this.color = KawaiiColors.pinkBottom,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = selected ? Colors.white : color;
    final bgColor = selected ? null : color.withValues(alpha: KawaiiOpacity.ghost);

    return GestureDetector(
      onTap: onSelected != null ? () => onSelected!(!selected) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: KawaiiCurves.soft,
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          gradient: selected
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.85),
                    color,
                  ],
                )
              : null,
          color: selected ? null : bgColor,
          borderRadius: BorderRadius.circular(KawaiiBorderRadius.md),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (avatar != null) ...[
              avatar!,
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: kBody(
                size: 12,
                weight: FontWeight.w700,
                color: textColor,
              ),
            ),
            if (onDeleted != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onDeleted,
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: textColor.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
