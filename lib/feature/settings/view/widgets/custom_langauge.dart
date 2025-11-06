import 'package:diyar_app/core/cubits/language/language_controller.dart';
import 'package:diyar_app/core/cubits/language/language_state.dart';
import 'package:diyar_app/core/enums/language_mode.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_container_language_or_theme.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLangauge extends StatelessWidget {
  const CustomLangauge({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageController, LanguageState>(
      builder: (context, state) {
        final languageController = LanguageController.get(context);
        final currentLang = languageController.currentLanguageMode;
        return Row(
          children: [
            CustomContainerLanguageOrTheme(
              text: LocaleKeys.english.tr(),
              onTap: () => languageController.changeCurrentLanguageMode(
                context,
                LanguagesMode.english,
              ),
              isSelected: currentLang == LanguagesMode.english,
            ),
            10.pw,
            CustomContainerLanguageOrTheme(
              text: LocaleKeys.arabic.tr(),
              onTap: () => languageController.changeCurrentLanguageMode(
                context,
                LanguagesMode.arabic,
              ),
              isSelected: currentLang == LanguagesMode.arabic,
            ),
          ],
        ).paddingSymmetric(horizontal: 16.w);
      },
    );
  }
}