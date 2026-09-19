import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/project/model/project_details_response_model.dart';
import 'package:diyar_app/feature/project/view/widgets/polygons_painter.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The project's master plan with the user's buildings drawn on top. Tapping
/// one calls [onBuildingTapped]. Signed out, owning nothing here, or without
/// a building map (not drawn yet), the plain master plan is shown.
class MasterPlanMap extends StatelessWidget {
  const MasterPlanMap({
    super.key,
    required this.project,
    this.onBuildingTapped,
    this.selectedBuildingId,
    this.borderRadius,
  });

  final ProjectData project;
  final ValueChanged<Building>? onBuildingTapped;

  /// Highlighted on the map (the building of the unit whose news is shown).
  final int? selectedBuildingId;
  final BorderRadius? borderRadius;

  static const double _fallbackAspectRatio = 16 / 9;

  /// The building whose shape contains [point] (normalised 0–1 coordinates),
  /// or null. Later shapes are drawn on top, so they win.
  static Building? hitTest(
    Offset point,
    List<(BuildingShape, Building)> shapes,
  ) {
    for (final (shape, building) in shapes.reversed) {
      final polygon = [for (final p in shape.points) Offset(p[0], p[1])];
      if (_contains(polygon, point)) return building;
    }
    return null;
  }

  static bool _contains(List<Offset> polygon, Offset point) {
    var inside = false;
    for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      final a = polygon[i], b = polygon[j];
      if ((a.dy > point.dy) != (b.dy > point.dy) &&
          point.dx < (b.dx - a.dx) * (point.dy - a.dy) / (b.dy - a.dy) + a.dx) {
        inside = !inside;
      }
    }
    return inside;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = project.mainImage?.url;
    final shapes = project.linkedShapes;
    if ((imageUrl == null || imageUrl.isEmpty) && shapes.isEmpty) {
      return const SizedBox.shrink();
    }
    final aspectRatio =
        project.buildingMapping?.aspectRatio ?? _fallbackAspectRatio;

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(14.r),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            final polygons = [
              for (final (shape, _) in shapes)
                MapPolygon(
                  points: [
                    for (final p in shape.points)
                      Offset(p[0] * size.width, p[1] * size.height),
                  ],
                  color: MasterPlanColors.owned,
                ),
            ];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: onBuildingTapped == null || shapes.isEmpty
                  ? null
                  : (details) {
                      final p = details.localPosition;
                      final building = hitTest(
                        Offset(p.dx / size.width, p.dy / size.height),
                        shapes,
                      );
                      if (building != null) onBuildingTapped!(building);
                    },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    CustomCachedNetworkImage(
                      isProjectDetails: true,
                      imageUrl: imageUrl,
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.fill,
                    )
                  else
                    ColoredBox(color: AppSurface.of(context).subtle),
                  if (polygons.isNotEmpty)
                    CustomPaint(
                      size: size,
                      painter: PolygonsPainter(
                        polygons,
                        selectedIndices: {
                          for (var i = 0; i < shapes.length; i++)
                            if (selectedBuildingId != null &&
                                shapes[i].$2.id == selectedBuildingId)
                              i,
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Explains the highlighted buildings on the map.
class MasterPlanLegend extends StatelessWidget {
  const MasterPlanLegend({super.key});

  @override
  Widget build(BuildContext context) {
    Widget item(Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.r,
          height: 12.r,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        6.pw,
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppSurface.of(context).textSecondary,
          ),
        ),
      ],
    );
    return Wrap(
      spacing: 16.w,
      runSpacing: 6.h,
      children: [
        item(MasterPlanColors.owned, LocaleKeys.legend_your_buildings.tr()),
      ],
    );
  }
}

/// Full-screen, zoomable master plan. Pops with the building the user tapped.
class MasterPlanFullScreen extends StatelessWidget {
  const MasterPlanFullScreen({
    super.key,
    required this.project,
    this.selectedBuildingId,
  });

  final ProjectData project;
  final int? selectedBuildingId;

  static Future<Building?> open(
    BuildContext context,
    ProjectData project, {
    int? selectedBuildingId,
  }) {
    return Navigator.of(context).push<Building>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => MasterPlanFullScreen(
          project: project,
          selectedBuildingId: selectedBuildingId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        foregroundColor: AppColors.whiteColor,
        title: Text(project.name ?? LocaleKeys.master_plan.tr()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: InteractiveViewer(
                maxScale: 6,
                child: Center(
                  child: MasterPlanMap(
                    project: project,
                    selectedBuildingId: selectedBuildingId,
                    borderRadius: BorderRadius.zero,
                    onBuildingTapped: (b) => Navigator.of(context).pop(b),
                  ),
                ),
              ),
            ),
            if (project.linkedShapes.isNotEmpty)
              Container(
                width: double.infinity,
                color: AppColors.whiteColor,
                padding: EdgeInsets.all(12.w),
                child: const MasterPlanLegend(),
              ),
          ],
        ),
      ),
    );
  }
}
