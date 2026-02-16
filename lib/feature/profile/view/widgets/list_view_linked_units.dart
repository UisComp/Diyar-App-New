import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/cubits/app_theme/app_theme_state.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_cached.dart';
import 'package:diyar_app/feature/profile/model/unit_model_details_for_linked_user.dart';
import 'package:diyar_app/feature/profile/model/user_units_response_model.dart';
import 'package:diyar_app/feature/profile/view/widgets/empty_linked_units.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:go_router/go_router.dart';

class ListViewLinkedUnits extends StatelessWidget {
  const ListViewLinkedUnits({
    super.key,
    required this.linkedUnits,
    this.unitData,
  });

  final List<UserUnit> linkedUnits;
  final UnitData? unitData;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppThemeController, AppThemeState>(
      builder: (context, state) {
        final darkTheme =
            AppThemeController.get(context).currentThemeMode ==
            AppThemeMode.dark;
        final cardColor = darkTheme ? AppColors.black87 : AppColors.whiteColor;
        // final cardImageColor = darkTheme
        //     ? AppColors.black87
        //     : AppColors.secondaryColor;
        final textColor = darkTheme
            ? AppColors.containerColor
            : AppColors.black87;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: context.locale.languageCode == 'en'
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Text(
                    LocaleKeys.own_units.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                12.ph,
                linkedUnits.isEmpty
                    ? SizedBox(height: 200.h, child: const EmptyLinkedUnits())
                    : Column(
                        children: linkedUnits.map((unit) {
                          return InkWell(
                            onTap: () async {
                              context.push(
                                RoutesName.linkedUnitsDetailScreen,
                                extra: unit,
                              );
                            },

                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: CachedImage(
                                      url: unit.imageUrl?.url ?? '',
                                      width: 50.w,
                                      height: 50.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Text(
                                      unit.name ?? '',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
