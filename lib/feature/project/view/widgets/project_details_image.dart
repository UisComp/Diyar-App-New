import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/project/controller/project_controller.dart';
import 'package:diyar_app/feature/project/model/project_details_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
class ProjectDetailsImage extends StatelessWidget {
  const ProjectDetailsImage({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.project,
  });

  final ProjectController controller;
  final bool isLoading;
  final ProjectDetailsResponseModel project;

  @override
  Widget build(BuildContext context) {
    final mapping = project.data?.unitMapping;
    if (mapping == null) return const SizedBox();

    final shapes = mapping.shapes ?? [];

    return LayoutBuilder(
      builder: (context, constraints) {
        final imgWidth = constraints.maxWidth;
        final imgHeight =
            (mapping.imageHeight! / mapping.imageWidth!) * imgWidth;

        return ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: SizedBox(
            width: imgWidth,
            height: imgHeight,
            child: Stack(
              children: [
                // الصورة الأساسية (حتى أثناء التحميل)
                CustomCachedNetworkImage(
                  isProjectDetails: true,
                  imageUrl: project.data?.mainImage?.url,
                  width: imgWidth,
                  height: imgHeight,
                  fit: BoxFit.cover,
                ),

                // طبقة التحميل نصف شفافة فوق الصورة
                if (isLoading)
                  Container(
                    width: double.infinity,
                    height: imgHeight,
                    color: Colors.grey.withOpacity(0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),

                // Polygon overlay & tap detection (only when loaded)
                if (!isLoading)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: (details) {
                      final tapPosition = details.localPosition;
                      for (final shape in shapes) {
                        final points = shape.points;
                        if (points == null || points.isEmpty) continue;

                        final pixelPoints = points
                            .map(
                              (p) => Offset(p[0] * imgWidth, p[1] * imgHeight),
                            )
                            .toList();

                        if (_isPointInPolygon(tapPosition, pixelPoints)) {
                          AppLogger.log(
                            "Tapped shape details: ${shape.toJson()}",
                          );
                          if (shape.unitId != null) {
                            context.push(
                              RoutesName.unitEvents,
                              extra: shape.unitId,
                            );
                          }
                          break;
                        }
                      }
                    },
                    child: CustomPaint(
                      size: Size(imgWidth, imgHeight),
                      painter: PolygonsPainter(
                        shapes.map((shape) {
                          final points = shape.points;
                          if (points == null || points.isEmpty) {
                            return <Offset>[];
                          }
                          return points
                              .map(
                                (p) =>
                                    Offset(p[0] * imgWidth, p[1] * imgHeight),
                              )
                              .toList();
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isPointInPolygon(Offset point, List<Offset> polygon) {
    bool inside = false;
    for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      if ((polygon[i].dy > point.dy) != (polygon[j].dy > point.dy) &&
          point.dx <
              (polygon[j].dx - polygon[i].dx) *
                      (point.dy - polygon[i].dy) /
                      (polygon[j].dy - polygon[i].dy) +
                  polygon[i].dx) {
        inside = !inside;
      }
    }
    return inside;
  }
}

class PolygonsPainter extends CustomPainter {
  final List<List<Offset>> polygons;

  PolygonsPainter(this.polygons);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.35)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.red
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
