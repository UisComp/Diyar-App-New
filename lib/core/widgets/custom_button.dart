// import 'package:diyar_app/core/style/app_color.dart';
// import 'package:diyar_app/core/style/app_style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomButton extends StatelessWidget {
//   const CustomButton({
//     super.key,
//     this.buttonColor,
//     this.textColor,
//     required this.buttonText,
//     required this.onPressed,
//     this.buttonHeight,
//   });
//   final Color? buttonColor;
//   final Color? textColor;
//   final String buttonText;
//   final double? buttonHeight;
//   final void Function()? onPressed;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialButton(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(10.r)),
//       ),
//       height: buttonHeight ?? 48.h,
//       minWidth: double.infinity,
//       onPressed: onPressed,
//       color: buttonColor ?? AppColors.secondaryColor,
//       child: Text(
//         buttonText,
//         style: AppStyle.fontSize16Regular.copyWith(
//           color: textColor ?? AppColors.whiteColor,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  });

  final Color? buttonColor;
  final Color? textColor;
  final String buttonText;
  final double? buttonHeight;
  final void Function()? onPressed;
  final bool isLoading;
  final double borderRadius;
  final Duration animationDuration;

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
                      : Text(
                          widget.buttonText,
                          key: const ValueKey('text'),
                          textAlign: TextAlign.center,
                          style: AppStyle.fontSize16Regular.copyWith(
                            color: widget.textColor ?? AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
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
