import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
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
    this.borderRadius = 10.0,
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
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final double targetWidth = widget.isLoading
            ? (widget.buttonHeight ?? 48.h)
            : maxWidth;

        return AnimatedContainer(
          duration: widget.animationDuration,
          curve: Curves.easeInOutCubic,
          width: targetWidth,
          height: widget.buttonHeight ?? 48.h,
          child: Material(
            color: widget.buttonColor ?? AppColors.secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(widget.borderRadius.r),
              ),
            ),
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onPressed,
              borderRadius: BorderRadius.all(
                Radius.circular(widget.borderRadius.r),
              ),
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
                          width: (widget.buttonHeight ?? 48.h) * 0.6,
                          height: (widget.buttonHeight ?? 48.h) * 0.6,
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
                                AppColors.lightCard,
                                BlendMode.srcIn,
                              ),
                            ),
                            10.pw,
                            Flexible(
                              child: Text(
                                widget.buttonText,
                                key: const ValueKey('text'),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: AppStyle.fontSize18Bold(context)
                                    .copyWith(
                                      fontSize: 16.sp,
                                      color:
                                          AppThemeController.get(
                                                context,
                                              ).currentThemeMode ==
                                              AppThemeMode.dark
                                          ? AppColors.blackColor
                                          : widget.textColor ??
                                                AppColors.whiteColor,
                                    ),
                              ),
                            ),
                          ],
                        )
                      // ? Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       SvgPicture.asset(
                      //         colorFilter: ColorFilter.mode(
                      //           AppColors.lightCard,
                      //           BlendMode.srcIn,
                      //         ),
                      //         widget.image!,
                      //         key: const ValueKey('image'),
                      //       ),
                      //       10.pw,
                      //       Text(
                      //         widget.buttonText,
                      //         key: const ValueKey('text'),
                      //         textAlign: TextAlign.center,
                      //         style: AppStyle.fontSize18Bold(context).copyWith(
                      //           fontSize: 16.sp,
                      //           color:
                      //               AppThemeController.get(
                      //                     context,
                      //                   ).currentThemeMode ==
                      //                   AppThemeMode.dark
                      //               ? AppColors.blackColor
                      //               : widget.textColor ?? AppColors.whiteColor,
                      //         ),
                      //       ),
                      //     ],
                      //   )
                      : Text(
                          widget.buttonText,
                          key: const ValueKey('text'),
                          textAlign: TextAlign.center,
                          style: AppStyle.fontSize18Bold(context).copyWith(
                            fontSize: 16.sp,
                            color:
                                AppThemeController.get(
                                      context,
                                    ).currentThemeMode ==
                                    AppThemeMode.dark
                                ? AppColors.blackColor
                                : widget.textColor ?? AppColors.whiteColor,
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
