import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.showIconNotification = false,
    required this.titleAppBar,
    this.isOtherIcon = false, this.otherIcon,
  });
  final bool? showIconNotification;
  final bool? isOtherIcon;
  final String titleAppBar;
  final Widget ?otherIcon;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      actions: showIconNotification == true
          ? [
              ?isOtherIcon == true
                  ?otherIcon
                  : IconButton(
                      onPressed: () {
                        context.push(RoutesName.notificationsScreen);
                      },
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
