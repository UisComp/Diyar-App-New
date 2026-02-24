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
      bottom: bottom,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      leading: leading,
      actions: actions,
      title: AppText(titleAppBar, style: AppStyle.fontSize18Bold(context)),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
