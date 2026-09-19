import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/core/widgets/empty_state_view.dart';
import 'package:diyar_app/feature/profile/model/user_units_response_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// "My Units" card on the profile: loading skeleton, error with retry, empty
/// state, or the list of the owner's units.
class ListViewLinkedUnits extends StatelessWidget {
  const ListViewLinkedUnits({
    super.key,
    required this.linkedUnits,
    required this.isLoading,
    required this.hasError,
    required this.onRetry,
  });

  final List<UserUnit> linkedUnits;
  final bool isLoading;
  final bool hasError;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);

    final Widget body;
    if (isLoading) {
      body = Skeletonizer(
        key: const ValueKey('loading'),
        child: Column(
          children: [
            for (var i = 0; i < 2; i++) ...[
              if (i > 0) Divider(height: 1, color: surface.border),
              const _UnitRow(unit: null),
            ],
          ],
        ),
      );
    } else if (hasError && linkedUnits.isEmpty) {
      body = Padding(
        key: const ValueKey('error'),
        padding: EdgeInsets.all(12.r),
        child: EmptyStateView.error(
          message: LocaleKeys.units_load_failed.tr(),
          onRetry: onRetry,
          boxed: false,
        ),
      );
    } else if (linkedUnits.isEmpty) {
      body = Padding(
        key: const ValueKey('empty'),
        padding: EdgeInsets.all(12.r),
        child: EmptyStateView(
          title: LocaleKeys.no_new_unit_available,
          message: LocaleKeys.no_units_desc.tr(),
          illustrationSize: 96.r,
          boxed: false,
        ),
      );
    } else {
      body = Column(
        key: const ValueKey('data'),
        children: [
          for (var i = 0; i < linkedUnits.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: 16.w,
                endIndent: 16.w,
                color: surface.border,
              ),
            _UnitRow(unit: linkedUnits[i]),
          ],
        ],
      );
    }

    return Container(
      width: double.infinity,
      decoration: surface.cardDecoration(radius: 20.r),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Row(
              children: [
                Icon(
                  Icons.home_work_outlined,
                  size: 20.sp,
                  color: AppColors.primaryColor,
                ),
                8.pw,
                Expanded(
                  child: Text(
                    LocaleKeys.my_units.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: surface.textPrimary,
                    ),
                  ),
                ),
                if (!isLoading && linkedUnits.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${linkedUnits.length}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: body,
          ),
          6.ph,
        ],
      ),
    );
  }
}

class _UnitRow extends StatelessWidget {
  const _UnitRow({required this.unit});

  /// Null renders placeholder content for the skeleton.
  final UserUnit? unit;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final unit = this.unit;
    final subtitle = unit == null ? 'Villa' : unit.building?.type.labelKey.tr();

    return InkWell(
      onTap: unit == null
          ? null
          : () => context.push(RoutesName.linkedUnitsDetailScreen, extra: unit),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: 52.r,
                height: 52.r,
                color: AppColors.primaryColor.withValues(alpha: 0.08),
                child: CustomCachedNetworkImage(
                  imageUrl: unit?.imageUrl?.url ?? '',
                  width: 52.r,
                  height: 52.r,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            12.pw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit?.label ?? 'Villa 10 · V-10',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: surface.textPrimary,
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    3.ph,
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        color: surface.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            8.pw,
            Icon(
              Directionality.of(context) == TextDirection.rtl
                  ? Icons.chevron_left_rounded
                  : Icons.chevron_right_rounded,
              size: 22.sp,
              color: surface.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
