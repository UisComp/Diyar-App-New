import 'package:diyar_app/core/style/app_style.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.titleAppBar,
    this.backgroundColor,
    this.actions,
    this.leading,
  });

  final String titleAppBar;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      leading: leading,
      actions: actions,
      title: Text(titleAppBar, style: AppStyle.fontSize18Bold(context)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
