import 'package:diyar_app/core/style/app_color.dart';
import 'package:flutter/material.dart';

class PolygonsPainter extends CustomPainter {
  final List<List<Offset>> polygons;

  /// Indices of polygons that should be drawn as "selected" (highlighted).
  final Set<int> selectedIndices;

  PolygonsPainter(this.polygons, {this.selectedIndices = const {}});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = AppColors.redColor.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = AppColors.redColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final selectedFillPaint = Paint()
      ..color = AppColors.primaryColor.withOpacity(0.40)
      ..style = PaintingStyle.fill;

    final selectedBorderPaint = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (int index = 0; index < polygons.length; index++) {
      final points = polygons[index];
      if (points.isEmpty) continue;

      final path = Path()..moveTo(points.first.dx, points.first.dy);

      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }

      path.close();

      final isSelected = selectedIndices.contains(index);
      canvas.drawPath(path, isSelected ? selectedFillPaint : fillPaint);
      canvas.drawPath(path, isSelected ? selectedBorderPaint : borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PolygonsPainter oldDelegate) =>
      oldDelegate.polygons != polygons ||
      oldDelegate.selectedIndices != selectedIndices;
}
