import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/extension/string_extension.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Opens [images] full screen, pinch- and double-tap-zoomable, starting at
/// [initialIndex]. Blank and duplicate urls are dropped; nothing opens when
/// none are left.
Future<void> openImageViewer(
  BuildContext context, {
  required List<String?> images,
  int initialIndex = 0,
  String? title,
  String? description,
}) {
  final urls = <String>[];
  for (final url in images) {
    final trimmed = url?.trim();
    if (trimmed == null || trimmed.isEmpty) continue;
    if (!urls.contains(trimmed)) urls.add(trimmed);
  }
  if (urls.isEmpty) return Future<void>.value();

  // The index refers to the caller's list, which may have lost entries above.
  final wanted = initialIndex >= 0 && initialIndex < images.length
      ? images[initialIndex]?.trim()
      : null;
  final start = wanted == null ? -1 : urls.indexOf(wanted);

  return Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: AppColors.blackColor,
      barrierDismissible: true,
      barrierLabel: 'ImagePreview',
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (_, _, _) => ZoomableImageViewer(
        images: urls,
        initialIndex: start < 0 ? 0 : start,
        title: title,
        description: description,
      ),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}

/// Full-screen image gallery: swipe between images, pinch or double-tap to
/// zoom, drag down to dismiss.
class ZoomableImageViewer extends StatefulWidget {
  const ZoomableImageViewer({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.title,
    this.description,
  });

  final List<String> images;
  final int initialIndex;
  final String? title;
  final String? description;

  @override
  State<ZoomableImageViewer> createState() => _ZoomableImageViewerState();
}

class _ZoomableImageViewerState extends State<ZoomableImageViewer> {
  late final PageController _pageController = PageController(
    initialPage: widget.initialIndex,
  );
  late int _index = widget.initialIndex;

  /// Paging is locked while the current image is zoomed in, so a pan doesn't
  /// flick to the next image.
  bool _zoomed = false;

  /// Vertical drag-to-dismiss, only when not zoomed.
  double _dragOffset = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_zoomed) return;
    setState(() => _dragOffset += details.delta.dy);
  }

  void _onDragEnd(DragEndDetails details) {
    if (_zoomed) return;
    final velocity = details.velocity.pixelsPerSecond.dy;
    if (_dragOffset.abs() > 120.h || velocity.abs() > 700) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() => _dragOffset = 0);
  }

  @override
  Widget build(BuildContext context) {
    final caption = widget.title?.trim() ?? '';
    final subtitle = widget.description?.trim() ?? '';
    final opacity = (1 - (_dragOffset.abs() / 400)).clamp(0.35, 1.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.blackColor.withValues(alpha: opacity),
        body: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onVerticalDragUpdate: _onDragUpdate,
              onVerticalDragEnd: _onDragEnd,
              child: Transform.translate(
                offset: Offset(0, _dragOffset),
                child: PageView.builder(
                  controller: _pageController,
                  physics: _zoomed
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  itemCount: widget.images.length,
                  onPageChanged: (i) => setState(() {
                    _index = i;
                    _zoomed = false;
                  }),
                  itemBuilder: (context, i) => _ZoomablePage(
                    key: ValueKey(widget.images[i]),
                    imageUrl: widget.images[i],
                    onZoomChanged: (zoomed) {
                      if (zoomed != _zoomed) setState(() => _zoomed = zoomed);
                    },
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              top: MediaQuery.paddingOf(context).top + 8.h,
              start: 12.w,
              end: 12.w,
              child: Row(
                children: [
                  _CircleButton(
                    icon: Directionality.of(context) == ui.TextDirection.rtl
                        ? Icons.arrow_forward_rounded
                        : Icons.arrow_back_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  if (widget.images.length > 1)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.black54Color,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: AppText(
                        '${_index + 1} / ${widget.images.length}',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  const Spacer(),
                  _CircleButton(
                    icon: Icons.close_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                ],
              ),
            ),
            if (caption.isNotEmpty || subtitle.isNotEmpty)
              PositionedDirectional(
                bottom: 0,
                start: 0,
                end: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    20.w,
                    24.h,
                    20.w,
                    MediaQuery.paddingOf(context).bottom + 20.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppColors.blackColor.withValues(alpha: 0.75),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (caption.isNotEmpty)
                        AppText(
                          caption.capitalize(),
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (subtitle.isNotEmpty) ...[
                        6.ph,
                        AppText(
                          subtitle.capitalize(),
                          style: TextStyle(
                            color: AppColors.white70Color,
                            fontSize: 13.sp,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// One image, zoomable in place. Double-tap zooms in on the tapped point and
/// a second double-tap resets.
class _ZoomablePage extends StatefulWidget {
  const _ZoomablePage({
    super.key,
    required this.imageUrl,
    required this.onZoomChanged,
  });

  final String imageUrl;
  final ValueChanged<bool> onZoomChanged;

  @override
  State<_ZoomablePage> createState() => _ZoomablePageState();
}

class _ZoomablePageState extends State<_ZoomablePage>
    with SingleTickerProviderStateMixin {
  static const double _doubleTapScale = 2.5;

  final TransformationController _controller = TransformationController();

  /// Built eagerly: a `late final` would be created by `dispose` on a page
  /// that was never zoomed, after its element is already deactivated.
  late final AnimationController _animation;

  Animation<Matrix4>? _animationValue;
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    _animation =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 220),
          )
          ..addListener(() {
            final value = _animationValue;
            if (value != null) _controller.value = value.value;
          });
    _controller.addListener(_reportZoom);
  }

  @override
  void dispose() {
    _controller.removeListener(_reportZoom);
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _reportZoom() {
    widget.onZoomChanged(_controller.value.getMaxScaleOnAxis() > 1.01);
  }

  void _animateTo(Matrix4 target) {
    _animationValue = Matrix4Tween(begin: _controller.value, end: target)
        .animate(CurvedAnimation(parent: _animation, curve: Curves.easeOut));
    _animation.forward(from: 0);
  }

  void _handleDoubleTap() {
    if (_controller.value.getMaxScaleOnAxis() > 1.01) {
      _animateTo(Matrix4.identity());
      return;
    }
    final position = _doubleTapDetails?.localPosition;
    if (position == null) return;
    _animateTo(
      Matrix4.identity()
        ..translateByDouble(
          -position.dx * (_doubleTapScale - 1),
          -position.dy * (_doubleTapScale - 1),
          0,
          1,
        )
        ..scaleByDouble(_doubleTapScale, _doubleTapScale, _doubleTapScale, 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (details) => _doubleTapDetails = details,
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _controller,
        minScale: 1,
        maxScale: 6,
        clipBehavior: Clip.none,
        child: SizedBox.expand(
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.contain,
            fadeInDuration: const Duration(milliseconds: 150),
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(color: AppColors.whiteColor),
            ),
            errorWidget: (context, url, error) => Center(
              child: Icon(
                Icons.broken_image_outlined,
                size: 56.sp,
                color: AppColors.white70Color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22.r),
        onTap: onTap,
        child: Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.black54Color,
          ),
          child: Icon(icon, color: AppColors.whiteColor, size: 22.sp),
        ),
      ),
    );
  }
}
