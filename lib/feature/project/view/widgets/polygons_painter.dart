import 'package:diyar_app/core/style/app_color.dart';
import 'package:flutter/material.dart';

/// Colors used for buildings on the master plan (also shown in the legend).
/// The API only returns the user's own buildings, so they share one color.
abstract class MasterPlanColors {
  static const Color owned = AppColors.primaryColor;
  static const Color selected = Color(0xFFFFB300);
}

class MapPolygon {
  const MapPolygon({required this.points, required this.color});

  final List<Offset> points;
  final Color color;
}

class PolygonsPainter extends CustomPainter {
  final List<MapPolygon> polygons;

  /// Indices of polygons that should be drawn as "selected" (highlighted).
  final Set<int> selectedIndices;

  PolygonsPainter(this.polygons, {this.selectedIndices = const {}});

  @override
  void paint(Canvas canvas, Size size) {
    for (int index = 0; index < polygons.length; index++) {
      final polygon = polygons[index];
      final points = polygon.points;
      if (points.length < 3) continue;

      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();

      final isSelected = selectedIndices.contains(index);
      final color = isSelected ? MasterPlanColors.selected : polygon.color;
      canvas.drawPath(
        path,
        Paint()
          ..color = color.withValues(alpha: isSelected ? 0.45 : 0.28)
          ..style = PaintingStyle.fill,
      );
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..strokeWidth = isSelected ? 3 : 1.8
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PolygonsPainter oldDelegate) =>
      oldDelegate.polygons != polygons ||
      oldDelegate.selectedIndices != selectedIndices;
}
