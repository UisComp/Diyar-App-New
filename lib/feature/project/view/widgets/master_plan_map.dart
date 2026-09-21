import 'dart:math' as math;

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
    this.onTapElsewhere,
    this.onDoubleTapAt,
    this.selectedBuildingId,
    this.borderRadius,
  });

  final ProjectData project;
  final ValueChanged<Building>? onBuildingTapped;

  /// A tap that missed every building (or on a map with no buildings drawn):
  /// the plan itself was tapped, e.g. to open it full screen.
  final VoidCallback? onTapElsewhere;

  /// Double-tap, with the screen position tapped: zoom in there. Taps are
  /// held back by a moment while this is set, so only the zoomable map
  /// passes it.
  final void Function(Offset globalPosition)? onDoubleTapAt;

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
              onDoubleTapDown: onDoubleTapAt == null
                  ? null
                  : (details) => onDoubleTapAt!(details.globalPosition),
              // Without this the double-tap never fires.
              onDoubleTap: onDoubleTapAt == null ? null : () {},
              onTapUp: onBuildingTapped == null && onTapElsewhere == null
                  ? null
                  : (details) {
                      final p = details.localPosition;
                      final building = shapes.isEmpty
                          ? null
                          : hitTest(
                              Offset(p.dx / size.width, p.dy / size.height),
                              shapes,
                            );
                      if (building != null && onBuildingTapped != null) {
                        onBuildingTapped!(building);
                      } else {
                        onTapElsewhere?.call();
                      }
                    },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    CustomCachedNetworkImage(
                      enablePreview: false,
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

/// Full-screen master plan: pinch, double-tap or use the buttons to zoom,
/// drag to move around. Pops with the building the user tapped.
class MasterPlanFullScreen extends StatefulWidget {
  const MasterPlanFullScreen({
    super.key,
    required this.project,
    this.selectedBuildingId,
    this.focusBuildingId,
  });

  final ProjectData project;
  final int? selectedBuildingId;

  /// Highlighted and zoomed to once the screen is up ("show on the map"
  /// from the units list).
  final int? focusBuildingId;

  static Future<Building?> open(
    BuildContext context,
    ProjectData project, {
    int? selectedBuildingId,
    int? focusBuildingId,
  }) {
    return Navigator.of(context).push<Building>(
      MaterialPageRoute(
        // A pushed route, not a dialog: the back arrow and the iOS edge
        // swipe both take the user back.
        builder: (_) => MasterPlanFullScreen(
          project: project,
          selectedBuildingId: selectedBuildingId,
          focusBuildingId: focusBuildingId,
        ),
      ),
    );
  }

  @override
  State<MasterPlanFullScreen> createState() => _MasterPlanFullScreenState();
}

class _MasterPlanFullScreenState extends State<MasterPlanFullScreen>
    with SingleTickerProviderStateMixin {
  static const double minScale = 1;
  static const double maxScale = 8;

  /// What a double-tap zooms to, and one step of the zoom buttons.
  static const double _doubleTapScale = 2.5;
  static const double _step = 1.6;

  /// Zooming to a building: it fills about 1 / [_focusPadding] of the
  /// screen, and a small villa isn't blown up past [_maxFocusScale].
  static const double _focusPadding = 2.4;
  static const double _maxFocusScale = 5;

  /// Room to bring an edge building to the middle.
  double get _boundaryMargin => 48.w;

  final TransformationController _controller = TransformationController();
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  );
  Animation<Matrix4>? _zoom;

  /// The viewer, so a screen position can be read in its coordinates.
  final GlobalKey _viewerKey = GlobalKey();

  /// The plan inside the viewer, to find where a building sits on screen.
  final GlobalKey _mapKey = GlobalKey();

  double get _scale => _controller.value.getMaxScaleOnAxis();

  @override
  void initState() {
    super.initState();
    _animation.addListener(() {
      if (_zoom != null) _controller.value = _zoom!.value;
    });
    // Keeps the zoom buttons in step with pinching.
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    if (widget.focusBuildingId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusOnceShown());
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _animateTo(
    Matrix4 target, {
    Duration duration = const Duration(milliseconds: 250),
  }) {
    _animation.duration = duration;
    _zoom = Matrix4Tween(
      begin: _controller.value,
      end: target,
    ).animate(CurvedAnimation(parent: _animation, curve: Curves.easeOutCubic));
    _animation.forward(from: 0);
  }

  /// Zooms to [scale] keeping [focal] (a point on the screen) in place.
  void _zoomTo(double scale, Offset focal) {
    final clamped = scale.clamp(minScale, maxScale);
    // The point of the plan under [focal] before zooming.
    final scene = _controller.toScene(focal);
    final target = Matrix4.identity()
      ..translateByDouble(focal.dx, focal.dy, 0, 1)
      ..scaleByDouble(clamped, clamped, clamped, 1)
      ..translateByDouble(-scene.dx, -scene.dy, 0, 1);
    _animateTo(target);
  }

  Offset _center() {
    final size = MediaQuery.sizeOf(context);
    return Offset(size.width / 2, size.height / 2);
  }

  void _zoomBy(double factor) => _zoomTo(_scale * factor, _center());

  /// Waits for the page to finish sliding in, so the zoom is seen.
  void _focusOnceShown() {
    if (!mounted) return;
    final animation = ModalRoute.of(context)?.animation;
    if (animation == null || animation.status == AnimationStatus.completed) {
      _focusBuilding();
      return;
    }
    void onStatus(AnimationStatus status) {
      if (status != AnimationStatus.completed) return;
      animation.removeStatusListener(onStatus);
      if (mounted) _focusBuilding();
    }

    animation.addStatusListener(onStatus);
  }

  /// All of [widget.focusBuildingId]'s shapes together, normalised 0–1.
  Rect? _focusBounds() {
    Rect? bounds;
    for (final (shape, building) in widget.project.linkedShapes) {
      if (building.id != widget.focusBuildingId) continue;
      for (final p in shape.points) {
        final point = Rect.fromLTWH(p[0], p[1], 0, 0);
        bounds = bounds?.expandToInclude(point) ?? point;
      }
    }
    return bounds;
  }

  /// Centres the focused building and zooms until it fills the screen.
  void _focusBuilding() {
    final bounds = _focusBounds();
    final viewer = _viewerKey.currentContext?.findRenderObject() as RenderBox?;
    final map = _mapKey.currentContext?.findRenderObject() as RenderBox?;
    if (bounds == null ||
        viewer == null ||
        map == null ||
        !viewer.hasSize ||
        !map.hasSize) {
      return;
    }
    final viewport = viewer.size;
    // Where the plan's corner is in the viewer's untransformed coordinates.
    final origin = _controller.toScene(
      viewer.globalToLocal(map.localToGlobal(Offset.zero)),
    );
    final plan = map.size;
    final building = Rect.fromLTRB(
      origin.dx + bounds.left * plan.width,
      origin.dy + bounds.top * plan.height,
      origin.dx + bounds.right * plan.width,
      origin.dy + bounds.bottom * plan.height,
    );
    final scale =
        (math.min(
                  viewport.width / math.max(building.width, 1),
                  viewport.height / math.max(building.height, 1),
                ) /
                _focusPadding)
            .clamp(minScale, _maxFocusScale);
    // Keeps the plan's edges within the viewer's boundary margin, as a
    // drag would, so the first pan afterwards doesn't jump.
    final margin = _boundaryMargin;
    final dx = (viewport.width / 2 - building.center.dx * scale).clamp(
      viewport.width - margin - viewport.width * scale,
      margin,
    );
    final dy = (viewport.height / 2 - building.center.dy * scale).clamp(
      viewport.height - margin - viewport.height * scale,
      margin,
    );
    _animateTo(
      Matrix4.identity()
        ..translateByDouble(dx, dy, 0, 1)
        ..scaleByDouble(scale, scale, scale, 1),
      duration: const Duration(milliseconds: 600),
    );
  }

  void _handleDoubleTap(Offset globalPosition) {
    if (_scale > minScale * 1.05) {
      _animateTo(Matrix4.identity());
      return;
    }
    final box = _viewerKey.currentContext?.findRenderObject() as RenderBox?;
    _zoomTo(
      _doubleTapScale,
      box == null ? _center() : box.globalToLocal(globalPosition),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canZoomOut = _scale > minScale * 1.05;
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        foregroundColor: AppColors.whiteColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        // The app's AppBarTheme paints icons and the title in the theme's
        // text colour, which is black in light mode: invisible on this bar.
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
        actionsIconTheme: const IconThemeData(color: AppColors.whiteColor),
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const BackButtonIcon(),
          color: AppColors.whiteColor,
        ),
        title: Text(
          widget.project.name ?? LocaleKeys.master_plan.tr(),
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          if (canZoomOut)
            IconButton(
              tooltip: LocaleKeys.reset_zoom.tr(),
              onPressed: () => _animateTo(Matrix4.identity()),
              icon: const Icon(Icons.zoom_out_map_rounded),
              color: AppColors.whiteColor,
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  InteractiveViewer(
                    key: _viewerKey,
                    transformationController: _controller,
                    minScale: minScale,
                    maxScale: maxScale,
                    boundaryMargin: EdgeInsets.all(_boundaryMargin),
                    child: Center(
                      child: MasterPlanMap(
                        key: _mapKey,
                        project: widget.project,
                        selectedBuildingId:
                            widget.focusBuildingId ?? widget.selectedBuildingId,
                        borderRadius: BorderRadius.zero,
                        onBuildingTapped: (b) => Navigator.of(context).pop(b),
                        onDoubleTapAt: _handleDoubleTap,
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    end: 12.w,
                    bottom: 12.h,
                    child: Column(
                      children: [
                        _ZoomButton(
                          icon: Icons.add_rounded,
                          tooltip: LocaleKeys.zoom_in.tr(),
                          onPressed: _scale < maxScale
                              ? () => _zoomBy(_step)
                              : null,
                        ),
                        8.ph,
                        _ZoomButton(
                          icon: Icons.remove_rounded,
                          tooltip: LocaleKeys.zoom_out.tr(),
                          onPressed: canZoomOut
                              ? () => _zoomBy(1 / _step)
                              : null,
                        ),
                      ],
                    ),
                  ),
                  if (!canZoomOut)
                    PositionedDirectional(
                      start: 12.w,
                      bottom: 16.h,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.pinch_rounded,
                            size: 16.sp,
                            color: AppColors.whiteColor.withValues(alpha: 0.8),
                          ),
                          6.pw,
                          Text(
                            LocaleKeys.pinch_to_zoom_hint.tr(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.whiteColor.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (widget.project.linkedShapes.isNotEmpty)
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

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.blackColor.withValues(alpha: 0.55),
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon),
        color: AppColors.whiteColor,
        disabledColor: AppColors.whiteColor.withValues(alpha: 0.35),
      ),
    );
  }
}
