import 'package:diyar_app/core/style/app_style.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.titleAppBar,
    this.backgroundColor,
    this.actions,
    this.leading,
    this.centerTitle,
  });

  final String titleAppBar;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? leading;
  final bool ?centerTitle ;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
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
