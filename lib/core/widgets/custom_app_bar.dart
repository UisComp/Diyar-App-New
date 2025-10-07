import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.showIconNotification = false,
    required this.titleAppBar,
  });
  final bool? showIconNotification;
  final String titleAppBar;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      actions: showIconNotification == true
          ? [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(Assets.images.svg.notification),
              ),
            ]
          : null,
      title: Text(titleAppBar, style: AppStyle.fontSize18Bold(context)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
