import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.titleAppBar,
    this.backgroundColor,
    this.actions,
    this.leading,
    this.centerTitle,
    this.bottom,
  });

  final String titleAppBar;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? leading;
  final bool? centerTitle;
  final PreferredSizeWidget? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: bottom ?? const _GradientAccentBottom(),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      leading: leading,
      actions: actions,
      title: AppText(titleAppBar, style: AppStyle.fontSize18Bold(context)),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight +
            (bottom?.preferredSize.height ?? _GradientAccentBottom.height),
      );
}

class _GradientAccentBottom extends StatelessWidget
    implements PreferredSizeWidget {
  const _GradientAccentBottom();
  static const double height = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(gradient: AppColors.accentGradient),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(height);
}
