import 'dart:math';
import 'package:flutter/material.dart';

/// 4-pointed sparkle star
class Star4Painter extends CustomPainter {
  final Color fill;
  final Color stroke;
  final double strokeWidth;

  const Star4Painter({
    this.fill = const Color(0xFFFFD54F),
    this.stroke = const Color(0xFFD4940C),
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = Path()
      ..moveTo(w * 0.5, 0)
      ..cubicTo(w * 0.5, 0, w * 0.58, h * 0.35, w, h * 0.5)
      ..cubicTo(w * 0.58, h * 0.65, w * 0.5, h, w * 0.5, h)
      ..cubicTo(w * 0.5, h, w * 0.42, h * 0.65, 0, h * 0.5)
      ..cubicTo(w * 0.42, h * 0.35, w * 0.5, 0, w * 0.5, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(path, Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round);
  }

  @override
  bool shouldRepaint(Star4Painter oldDelegate) =>
      oldDelegate.fill != fill ||
      oldDelegate.stroke != stroke ||
      oldDelegate.strokeWidth != strokeWidth;
}

/// Heart icon
class HeartPainter extends CustomPainter {
  final Color fill;
  final Color stroke;
  const HeartPainter({this.fill = const Color(0xFFF06292), this.stroke = const Color(0xFFC2185B)});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = Path()
      ..moveTo(w * 0.5, h * 0.84)
      ..cubicTo(w * 0.375, h * 0.72, w * 0.08, h * 0.56, w * 0.08, h * 0.34)
      ..cubicTo(w * 0.08, h * 0.18, w * 0.2, h * 0.12, w * 0.33, h * 0.17)
      ..cubicTo(w * 0.4, h * 0.2, w * 0.46, h * 0.28, w * 0.5, h * 0.38)
      ..cubicTo(w * 0.54, h * 0.28, w * 0.6, h * 0.2, w * 0.67, h * 0.17)
      ..cubicTo(w * 0.8, h * 0.12, w * 0.92, h * 0.18, w * 0.92, h * 0.34)
      ..cubicTo(w * 0.92, h * 0.56, w * 0.625, h * 0.72, w * 0.5, h * 0.84)
      ..close();
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(path, Paint()
      ..color = stroke..style = PaintingStyle.stroke..strokeWidth = 2..strokeJoin = StrokeJoin.round);
  }

  @override
  bool shouldRepaint(HeartPainter oldDelegate) =>
      oldDelegate.fill != fill || oldDelegate.stroke != stroke;
}

/// Dress icon
class DressPainter extends CustomPainter {
  final Color fill;
  final Color stroke;
  const DressPainter({this.fill = const Color(0xFFF8BBD0), this.stroke = const Color(0xFFF06292)});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final fPaint = Paint()..color = fill;
    final sPaint = Paint()..color = stroke..style = PaintingStyle.stroke..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

    final body = Path()
      ..moveTo(w * 0.4, h * 0.12)
      ..lineTo(w * 0.33, h * 0.4)
      ..lineTo(w * 0.15, h * 0.85)
      ..lineTo(w * 0.85, h * 0.85)
      ..lineTo(w * 0.67, h * 0.4)
      ..lineTo(w * 0.6, h * 0.12)
      ..close();
    canvas.drawPath(body, fPaint);
    canvas.drawPath(body, sPaint);

    final neck = Path()
      ..moveTo(w * 0.4, h * 0.12)
      ..quadraticBezierTo(w * 0.5, h * 0.22, w * 0.6, h * 0.12);
    canvas.drawPath(neck, sPaint);
    canvas.drawLine(Offset(w * 0.33, h * 0.4), Offset(w * 0.67, h * 0.4), sPaint);
  }

  @override
  bool shouldRepaint(DressPainter oldDelegate) =>
      oldDelegate.fill != fill || oldDelegate.stroke != stroke;
}

/// Dumbbell icon
class DumbbellPainter extends CustomPainter {
  final Color fill;
  final Color stroke;
  const DumbbellPainter({this.fill = const Color(0xFFA5D6A7), this.stroke = const Color(0xFF388E3C)});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final sPaint = Paint()..color = stroke..style = PaintingStyle.stroke..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final fPaint = Paint()..color = fill;

    canvas.drawLine(Offset(w * 0.3, h * 0.5), Offset(w * 0.7, h * 0.5), sPaint);
    for (final x in [w * 0.1, w * 0.7]) {
      final r = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, h * 0.3, w * 0.2, h * 0.4), const Radius.circular(4));
      canvas.drawRRect(r, fPaint);
      canvas.drawRRect(r, Paint()..color = stroke..style = PaintingStyle.stroke..strokeWidth = 2.5);
    }
  }

  @override
  bool shouldRepaint(DumbbellPainter oldDelegate) =>
      oldDelegate.fill != fill || oldDelegate.stroke != stroke;
}

/// Moon icon
class MoonPainter extends CustomPainter {
  final Color fill;
  final Color stroke;
  const MoonPainter({this.fill = const Color(0xFFD1C4E9), this.stroke = const Color(0xFF7C4DFF)});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = Path()
      ..moveTo(w * 0.7, h * 0.15)
      ..arcToPoint(Offset(w * 0.7, h * 0.85), radius: Radius.circular(w * 0.38), clockwise: false)
      ..arcToPoint(Offset(w * 0.7, h * 0.15), radius: Radius.circular(w * 0.28), clockwise: true);
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(path, Paint()..color = stroke..style = PaintingStyle.stroke..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.round);
    canvas.drawCircle(Offset(w * 0.62, h * 0.28), 2.5, Paint()..color = stroke);
    canvas.drawCircle(Offset(w * 0.74, h * 0.42), 1.8, Paint()..color = stroke);
  }

  @override
  bool shouldRepaint(MoonPainter oldDelegate) =>
      oldDelegate.fill != fill || oldDelegate.stroke != stroke;
}

/// Pen/pencil icon
class PenPainter extends CustomPainter {
  final Color stroke;
  const PenPainter({this.stroke = const Color(0xFFFF8A65)});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final paint = Paint()..color = stroke..style = PaintingStyle.stroke..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(w * 0.18, h * 0.82)
      ..lineTo(w * 0.32, h * 0.48)
      ..lineTo(w * 0.72, h * 0.08)
      ..lineTo(w * 0.92, h * 0.28)
      ..lineTo(w * 0.52, h * 0.68)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(w * 0.18, h * 0.82), 3, Paint()..color = stroke);
  }

  @override
  bool shouldRepaint(PenPainter oldDelegate) =>
      oldDelegate.stroke != stroke;
}

/// Music note icon
class MusicNotePainter extends CustomPainter {
  final Color fill;
  final Color stroke;
  const MusicNotePainter({this.fill = const Color(0xFFCE93D8), this.stroke = const Color(0xFF7B1FA2)});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final paint = Paint()..color = stroke..style = PaintingStyle.stroke..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;

    canvas.drawLine(Offset(w * 0.35, h * 0.78), Offset(w * 0.35, h * 0.25), paint);
    canvas.drawLine(Offset(w * 0.35, h * 0.25), Offset(w * 0.75, h * 0.15), paint);
    canvas.drawLine(Offset(w * 0.75, h * 0.68), Offset(w * 0.75, h * 0.15), paint);

    for (final c in [Offset(w * 0.25, h * 0.78), Offset(w * 0.65, h * 0.68)]) {
      canvas.drawCircle(c, w * 0.12, Paint()..color = fill);
      canvas.drawCircle(c, w * 0.12, Paint()..color = stroke..style = PaintingStyle.stroke..strokeWidth = 2.5);
    }
  }

  @override
  bool shouldRepaint(MusicNotePainter oldDelegate) =>
      oldDelegate.fill != fill || oldDelegate.stroke != stroke;
}

/// Search magnifying glass icon
class SearchIconPainter extends CustomPainter {
  final Color color;
  const SearchIconPainter({this.color = const Color(0xFF9D7088)});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(w * 0.42, h * 0.42), w * 0.25, paint);
    canvas.drawLine(Offset(w * 0.6, h * 0.6), Offset(w * 0.85, h * 0.85), paint);
  }

  @override
  bool shouldRepaint(SearchIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Chat bubble icon
class ChatBubblePainter extends CustomPainter {
  final Color color;
  const ChatBubblePainter({this.color = const Color(0xFFF06292)});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.5
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(w * 0.16, h * 0.22)
      ..lineTo(w * 0.72, h * 0.22)
      ..arcToPoint(Offset(w * 0.84, h * 0.34), radius: const Radius.circular(6))
      ..lineTo(w * 0.84, h * 0.58)
      ..arcToPoint(Offset(w * 0.72, h * 0.7), radius: const Radius.circular(6))
      ..lineTo(w * 0.46, h * 0.7)
      ..lineTo(w * 0.3, h * 0.84)
      ..lineTo(w * 0.3, h * 0.7)
      ..lineTo(w * 0.24, h * 0.7)
      ..arcToPoint(Offset(w * 0.16, h * 0.58), radius: const Radius.circular(6))
      ..close();
    canvas.drawPath(path, paint);
    for (final cx in [w * 0.38, w * 0.5, w * 0.62]) {
      canvas.drawCircle(Offset(cx, h * 0.47), 2.2, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(ChatBubblePainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Bell/notification icon
class BellPainter extends CustomPainter {
  final Color color;
  const BellPainter({this.color = const Color(0xFFF06292)});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final bell = Path()
      ..moveTo(w * 0.5, h * 0.1)
      ..cubicTo(w * 0.5, h * 0.1, w * 0.25, h * 0.18, w * 0.25, h * 0.45)
      ..lineTo(w * 0.18, h * 0.7)
      ..lineTo(w * 0.82, h * 0.7)
      ..lineTo(w * 0.75, h * 0.45)
      ..cubicTo(w * 0.75, h * 0.18, w * 0.5, h * 0.1, w * 0.5, h * 0.1);
    canvas.drawPath(bell, paint);
    final clapper = Path()
      ..moveTo(w * 0.38, h * 0.7)
      ..cubicTo(w * 0.38, h * 0.8, w * 0.44, h * 0.85, w * 0.5, h * 0.85)
      ..cubicTo(w * 0.56, h * 0.85, w * 0.62, h * 0.8, w * 0.62, h * 0.7);
    canvas.drawPath(clapper, paint);
  }

  @override
  bool shouldRepaint(BellPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Send/paper plane icon
class SendPainter extends CustomPainter {
  final Color color;
  const SendPainter({this.color = const Color(0xFF6D2042)});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(w * 0.15, h * 0.5)
      ..lineTo(w * 0.08, h * 0.22)
      ..lineTo(w * 0.9, h * 0.5)
      ..lineTo(w * 0.08, h * 0.78)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawLine(Offset(w * 0.15, h * 0.5), Offset(w * 0.42, h * 0.5), paint);
  }

  @override
  bool shouldRepaint(SendPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Checkmark icon
class CheckPainter extends CustomPainter {
  final Color color;
  const CheckPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.18, h * 0.5)
        ..lineTo(w * 0.42, h * 0.75)
        ..lineTo(w * 0.82, h * 0.25),
      Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 3
        ..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(CheckPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Right arrow icon
class ArrowPainter extends CustomPainter {
  final Color color;
  const ArrowPainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 3
      ..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    canvas.drawLine(Offset(w * 0.25, h * 0.5), Offset(w * 0.7, h * 0.5), paint);
    canvas.drawLine(Offset(w * 0.52, h * 0.3), Offset(w * 0.72, h * 0.5), paint);
    canvas.drawLine(Offset(w * 0.72, h * 0.5), Offset(w * 0.52, h * 0.7), paint);
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Play triangle icon
class PlayTrianglePainter extends CustomPainter {
  final Color color;
  const PlayTrianglePainter({this.color = Colors.white});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = Path()
      ..moveTo(w * 0.22, h * 0.12)..lineTo(w * 0.88, h * 0.5)..lineTo(w * 0.22, h * 0.88)..close();
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round);
  }

  @override
  bool shouldRepaint(PlayTrianglePainter oldDelegate) =>
      oldDelegate.color != color;
}

/// Animated sparkle with pulse/scale/rotate
/// [OPT #5] Slowed animation duration to 6 seconds (was 3s default) to
/// reduce repaint frequency for this ambient decoration.
class SparkleWidget extends StatefulWidget {
  final double size;
  final Color fill, stroke;
  final Duration duration;

  const SparkleWidget({
    super.key, this.size = 14,
    this.fill = const Color(0xFFFFD54F), this.stroke = const Color(0xFFD4940C),
    this.duration = const Duration(seconds: 6),
  });

  @override
  State<SparkleWidget> createState() => _SparkleWidgetState();
}

class _SparkleWidgetState extends State<SparkleWidget> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          final t = _ctrl.value;
          double scale, opacity;
          if (t < 0.3) {
            scale = 1.0 + 0.3 * (t / 0.3); opacity = 0.35 + 0.4 * (t / 0.3);
          } else if (t < 0.6) {
            scale = 1.3 - 0.6 * ((t - 0.3) / 0.3); opacity = 0.75 - 0.55 * ((t - 0.3) / 0.3);
          } else {
            scale = 0.7 + 0.3 * ((t - 0.6) / 0.4); opacity = 0.2 + 0.15 * ((t - 0.6) / 0.4);
          }
          final rot = t < 0.3 ? 15.0 * (t / 0.3) * pi / 180 : 0.0;
          return Transform.scale(scale: scale,
            child: Transform.rotate(angle: rot,
              child: Opacity(opacity: opacity, child: child)));
        },
        child: SizedBox(width: widget.size, height: widget.size,
          child: CustomPaint(painter: Star4Painter(fill: widget.fill, stroke: widget.stroke, strokeWidth: 1))),
      ),
    );
  }
}
