import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/feature/profile/controller/profile_controller.dart';
import 'package:diyar_app/feature/profile/controller/profile_state.dart';
import 'package:diyar_app/feature/visitor/controller/visitor_controller.dart';
import 'package:diyar_app/feature/visitor/view/widgets/visitor_form_widgets.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnitDropdownField extends StatelessWidget {
  const UnitDropdownField({
    super.key,
    required this.profileController,
    required this.visitorController,
  });

  final ProfileController profileController;
  final VisitorController visitorController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileController, ProfileState>(
      buildWhen: (_, state) =>
          state is GetUserLinkedUnitsLoadingState ||
          state is GetUserLinkedUnitsSuccessfullyState ||
          state is GetUserLinkedUnitsFailureState,
      builder: (context, state) {
        final units = profileController.userLinkedUnitsResponseModel.data ?? [];

        if (state is GetUserLinkedUnitsLoadingState) {
          return _UnitPlaceholder(
            message: LocaleKeys.loading_units.tr(),
            leading: SizedBox(
              width: 16.sp,
              height: 16.sp,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primaryColor,
              ),
            ),
          );
        }

        if (units.isEmpty) {
          return _UnitPlaceholder(
            message: LocaleKeys.no_linked_units.tr(),
            leading: Icon(
              Icons.info_outline,
              size: 18.sp,
              color: VisitorFormTheme.hint(context),
            ),
          );
        }

        return DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          value: visitorController.selectedUnitId,
          isExpanded: true,
          borderRadius: BorderRadius.all(Radius.circular(14.r)),
          dropdownColor: VisitorFormTheme.surface(context),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.primaryColor,
            size: 24.sp,
          ),
          style: AppStyle.fontSize14Regular(context),
          decoration: _decoration(context),
          hint: AppText(
            LocaleKeys.choose_a_linked_unit.tr(),
            style: AppStyle.fontSize16Regular(
              context,
            ).copyWith(fontSize: 14.sp, color: VisitorFormTheme.hint(context)),
          ),
          items: units
              .map(
                (unit) => DropdownMenuItem(
                  value: unit.id.toString(),
                  child: AppText(
                    unit.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.fontSize14Regular(context),
                  ),
                ),
              )
              .toList(),
          validator: (value) => (value == null || value.isEmpty)
              ? LocaleKeys.please_select_a_unit.tr()
              : null,
          onChanged: visitorController.onUnitChanged,
        );
      },
    );
  }

  InputDecoration _decoration(BuildContext context) {
    final radius = VisitorFormTheme.fieldRadius;
    final borderColor = VisitorFormTheme.border(context);
    return InputDecoration(
      filled: true,
      fillColor: VisitorFormTheme.field(context),
      prefixIcon: Icon(
        Icons.home_work_outlined,
        size: 20.sp,
        color: AppColors.primaryColor,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: radius,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: radius,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.6),
        borderRadius: radius,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.redColor),
        borderRadius: radius,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.redColor, width: 1.6),
        borderRadius: radius,
      ),
    );
  }
}

class _UnitPlaceholder extends StatelessWidget {
  const _UnitPlaceholder({required this.message, required this.leading});

  final String message;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: VisitorFormTheme.field(context),
        borderRadius: VisitorFormTheme.fieldRadius,
        border: Border.all(color: VisitorFormTheme.border(context)),
      ),
      child: Row(
        children: [
          leading,
          12.pw,
          Expanded(
            child: AppText(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.fontSize16Regular(
                context,
              ).copyWith(fontSize: 14.sp, color: VisitorFormTheme.hint(context)),
            ),
          ),
        ],
      ),
    );
  }
}
