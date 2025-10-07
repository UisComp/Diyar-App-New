
import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_state.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_container_language_or_theme.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomThemeApp extends StatelessWidget {
  const CustomThemeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeController, AppThemeState>(
      builder: (context, appThemeState) {
        final appThemeController = AppThemeController.get(context);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomContainerLanguageOrTheme(
                text: LocaleKeys.light.tr(),
                onTap: () => appThemeController.changeTheme(AppThemeMode.light),
                isSelected:
                    appThemeController.currentThemeMode == AppThemeMode.light,
              ),
            ),
            10.pw,
            Expanded(
              child: CustomContainerLanguageOrTheme(
                text: LocaleKeys.dark.tr(),
                onTap: () => appThemeController.changeTheme(AppThemeMode.dark),
                isSelected:
                    appThemeController.currentThemeMode == AppThemeMode.dark,
              ),
            ),
            10.pw,
            Expanded(
              child: CustomContainerLanguageOrTheme(
                text: LocaleKeys.system.tr(),
                onTap: () =>
                    appThemeController.changeTheme(AppThemeMode.system),
                isSelected:
                    appThemeController.currentThemeMode == AppThemeMode.system,
              ),
            ),
          ],
        );
      },
    ).paddingSymmetric(horizontal: 16.w);
  }
}
