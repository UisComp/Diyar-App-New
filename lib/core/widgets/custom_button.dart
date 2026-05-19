import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    this.buttonColor,
    this.textColor,
    required this.buttonText,
    required this.onPressed,
    this.buttonHeight,
    this.isLoading = false,
    this.borderRadius = 14.0,
    this.animationDuration = const Duration(milliseconds: 350),
    this.image,
  });

  final Color? buttonColor;
  final Color? textColor;
  final String buttonText;
  final double? buttonHeight;
  final void Function()? onPressed;
  final bool isLoading;
  final double borderRadius;
  final Duration animationDuration;
  final String? image;
  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with TickerProviderStateMixin {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isPrimary =
        widget.buttonColor == null || widget.buttonColor == AppColors.primaryColor;
    final BorderRadius radius =
        BorderRadius.all(Radius.circular(widget.borderRadius.r));

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final double targetWidth = widget.isLoading
            ? (widget.buttonHeight ?? 52.h)
            : maxWidth;

        final Color resolvedTextColor = isPrimary
            ? AppColors.whiteColor
            : (widget.textColor ??
                (AppThemeController.get(context).currentThemeMode ==
                        AppThemeMode.dark
                    ? AppColors.blackColor
                    : AppColors.whiteColor));

        return AnimatedContainer(
          duration: widget.animationDuration,
          curve: Curves.easeInOutCubic,
          width: targetWidth,
          height: widget.buttonHeight ?? 52.h,
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: isPrimary ? AppColors.accentGradient : null,
            color: isPrimary ? null : widget.buttonColor,
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: AppColors.accentHoverColor.withValues(
                        alpha: _pressed ? 0.55 : 0.32,
                      ),
                      blurRadius: _pressed ? 22 : 16,
                      spreadRadius: _pressed ? 1 : 0,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              onHighlightChanged: (v) => setState(() => _pressed = v),
              borderRadius: radius,
              splashColor: AppColors.accentHoverColor.withValues(alpha: 0.25),
              highlightColor:
                  AppColors.accentHoverColor.withValues(alpha: 0.18),
              child: Center(
                child: AnimatedSwitcher(
                  duration: widget.animationDuration,
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (child, anim) {
                    return FadeTransition(
                      opacity: anim,
                      child: ScaleTransition(scale: anim, child: child),
                    );
                  },
                  child: widget.isLoading
                      ? SizedBox(
                          key: const ValueKey('loading'),
                          width: (widget.buttonHeight ?? 52.h) * 0.55,
                          height: (widget.buttonHeight ?? 52.h) * 0.55,
                          child: const CircularProgressIndicator(
                            color: AppColors.whiteColor,
                            strokeWidth: 2.4,
                          ),
                        )
                      : widget.image != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  widget.image!,
                                  key: const ValueKey('image'),
                                  colorFilter: ColorFilter.mode(
                                    resolvedTextColor,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                10.pw,
                                Flexible(
                                  child: AppText(
                                    widget.buttonText,
                                    key: const ValueKey('text'),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: AppStyle.fontSize18Bold(context)
                                        .copyWith(
                                      fontSize: 16.sp,
                                      color: resolvedTextColor,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : AppText(
                              widget.buttonText,
                              key: const ValueKey('text'),
                              textAlign: TextAlign.center,
                              style: AppStyle.fontSize18Bold(context).copyWith(
                                fontSize: 16.sp,
                                color: resolvedTextColor,
                                letterSpacing: 0.3,
                              ),
                            ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
