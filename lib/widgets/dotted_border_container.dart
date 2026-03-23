import 'package:flutter/material.dart';

class DashedBorderBox extends StatelessWidget {
  final Widget child;
  final double dashWidth;
  final double dashGap;
  final double strokeWidth;
  final Color color;
  final bool showTop;
  final bool showBottom;
  final bool showLeft;
  final bool showRight;

  const DashedBorderBox({
    super.key,
    required this.child,
    this.dashWidth = 2,
    this.dashGap = 1,
    this.strokeWidth = 1,
    this.color = const Color(0xFFDDDDDD),
    this.showTop = false,
    this.showBottom = false,
    this.showLeft = false,
    this.showRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        dashWidth: dashWidth,
        dashGap: dashGap,
        strokeWidth: strokeWidth,
        color: color,
        showTop: showTop,
        showBottom: showBottom,
        showLeft: showLeft,
        showRight: showRight,
      ),
      child: Container(
        padding: EdgeInsets.only(top: 10,bottom: 10),
          child: child),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final double dashWidth;
  final double dashGap;
  final double strokeWidth;
  final Color color;
  final bool showTop;
  final bool showBottom;
  final bool showLeft;
  final bool showRight;

  _DashedBorderPainter({
    required this.dashWidth,
    required this.dashGap,
    required this.strokeWidth,
    required this.color,
    required this.showTop,
    required this.showBottom,
    required this.showLeft,
    required this.showRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    void drawLine(double startX, double startY, double endX, double endY) {
      double totalLength = (endX - startX).abs() > (endY - startY).abs()
          ? (endX - startX).abs()
          : (endY - startY).abs();
      double drawn = 0;

      while (drawn < totalLength) {
        final currentStartX = startX + (endX - startX) * (drawn / totalLength);
        final currentStartY = startY + (endY - startY) * (drawn / totalLength);
        final nextEndX = startX + (endX - startX) * ((drawn + dashWidth).clamp(0, totalLength) / totalLength);
        final nextEndY = startY + (endY - startY) * ((drawn + dashWidth).clamp(0, totalLength) / totalLength);

        canvas.drawLine(Offset(currentStartX, currentStartY), Offset(nextEndX, nextEndY), paint);
        drawn += dashWidth + dashGap;
      }
    }

    if (showTop) drawLine(0, 0, size.width, 0);
    if (showBottom) drawLine(0, size.height, size.width, size.height);
    if (showLeft) drawLine(0, 0, 0, size.height);
    if (showRight) drawLine(size.width, 0, size.width, size.height);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class ForSideDashedBorderBox extends StatelessWidget {
  final Widget child;
  final double dashWidth;
  final double dashGap;
  final double strokeWidth;
  final Color color;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ForSideDashedBorderBox({
    super.key,
    required this.child,
    this.dashWidth = 2,
    this.dashGap = 1,
    this.strokeWidth = 1.5,
    this.color = const Color(0xffe6e6e6),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.backgroundColor,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ForSideDashedBorderBox(
        dashWidth: dashWidth,
        dashGap: dashGap,
        strokeWidth: strokeWidth,
        color: color,
        borderRadius: borderRadius,
      ),
      child: Container(
        margin: margin,
        padding: padding ?? const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: child,
      ),
    );
  }
}

class _ForSideDashedBorderBox extends CustomPainter {
  final double dashWidth;
  final double dashGap;
  final double strokeWidth;
  final Color color;
  final BorderRadius borderRadius;

  _ForSideDashedBorderBox({
    required this.dashWidth,
    required this.dashGap,
    required this.strokeWidth,
    required this.color,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rect = Offset.zero & size;
    final rrect = borderRadius.toRRect(rect);

    final path = Path()..addRRect(rrect);

    // 🔥 Draw dashed path (including rounded corners)
    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final pathSegment = metric.extractPath(
          distance,
          distance + dashWidth,
        );

        canvas.drawPath(pathSegment, paint);

        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}