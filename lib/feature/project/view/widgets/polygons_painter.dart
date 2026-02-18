
import 'package:diyar_app/core/style/app_color.dart';
import 'package:flutter/material.dart';

class PolygonsPainter extends CustomPainter {
  final List<List<Offset>> polygons;

  PolygonsPainter(this.polygons);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.redColor.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppColors.redColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (final points in polygons) {
      if (points.isEmpty) continue;

      final path = Path()..moveTo(points.first.dx, points.first.dy);

      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }

      path.close();

      canvas.drawPath(path, paint);
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
