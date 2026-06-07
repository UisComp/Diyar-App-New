import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Modern month timeline for a single [year] with year navigation. Months can
/// be multi-selected; months after [lastAvailableMonth] are "blacked out"
/// (disabled) because they have not arrived yet. Tapping an available month
/// calls [onMonthTapped] with its 1-based index.
class MonthTimelineSelector extends StatefulWidget {
  const MonthTimelineSelector({
    super.key,
    required this.year,
    required this.selectedMonths,
    required this.lastAvailableMonth,
    required this.onMonthTapped,
    this.onPrevYear,
    this.onNextYear,
    this.enabled = true,
  });

  /// Calendar year the strip represents (e.g. 2026).
  final int year;

  /// 1-based month indices currently selected.
  final Set<int> selectedMonths;

  /// Highest 1-based month that can be selected; later months are disabled.
  final int lastAvailableMonth;

  /// Called with the 1-based month index when an available month is tapped.
  final ValueChanged<int> onMonthTapped;

  /// Goes to the previous year. Disabled (greyed) when null.
  final VoidCallback? onPrevYear;

  /// Goes to the next year. Disabled (greyed) when null.
  final VoidCallback? onNextYear;

  /// While false (e.g. a request is in flight) all interaction is ignored.
  final bool enabled;

  @override
  State<MonthTimelineSelector> createState() => _MonthTimelineSelectorState();
}

class _MonthTimelineSelectorState extends State<MonthTimelineSelector> {
  final ScrollController _scrollController = ScrollController();

  static const double _itemWidth = 60;
  static const double _itemGap = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
  }

  @override
  void didUpdateWidget(covariant MonthTimelineSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.year != widget.year) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrent());
    }
  }

  /// Bring the most recent available month into view so the user starts at the
  /// meaningful end of the timeline.
  void _scrollToCurrent() {
    if (!_scrollController.hasClients) return;
    final offset =
        (_itemWidth + _itemGap).w * (widget.lastAvailableMonth - 1) - 90.w;
    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _yearNavBar(context),
        14.ph,
        SizedBox(
          height: 50.h,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            itemCount: 12,
            separatorBuilder: (_, _) => SizedBox(width: _itemGap.w),
            itemBuilder: (context, i) => _monthNode(i + 1),
          ),
        ),
      ],
    );
  }

  Widget _yearNavBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _yearArrow(Icons.chevron_left_rounded, widget.onPrevYear),
        Column(
          children: [
            AppText(
              widget.year.toString(),
              style: AppStyle.fontSize18Bold(context).copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            4.ph,
            Container(
              width: 28.w,
              height: 3.h,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ],
        ),
        _yearArrow(Icons.chevron_right_rounded, widget.onNextYear),
      ],
    );
  }

  Widget _yearArrow(IconData icon, VoidCallback? onTap) {
    final isEnabled = onTap != null && widget.enabled;
    return Material(
      color: isEnabled
          ? AppColors.primaryColor.withValues(alpha: 0.08)
          : AppColors.containerColor,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        child: Padding(
          padding: EdgeInsets.all(6.r),
          child: Icon(
            icon,
            size: 26.sp,
            color: isEnabled
                ? AppColors.primaryColor
                : AppColors.greyColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _monthNode(int month) {
    final isSelected = widget.selectedMonths.contains(month);
    final isBlackout = month > widget.lastAvailableMonth;
    final isCurrent = month == widget.lastAvailableMonth;
    final label = AppFormatter.monthShortFormatter()
        .format(DateTime(widget.year, month));

    final Color bgColor;
    final Color textColor;
    if (isBlackout) {
      bgColor = AppColors.containerColor;
      textColor = AppColors.greyColor;
    } else if (isSelected) {
      bgColor = AppColors.primaryColor;
      textColor = AppColors.whiteColor;
    } else {
      bgColor = AppColors.primaryColor.withValues(alpha: 0.07);
      textColor = AppColors.primaryColor;
    }

    return GestureDetector(
      onTap: (isBlackout || !widget.enabled)
          ? null
          : () => widget.onMonthTapped(month),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: _itemWidth.w,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : (isCurrent && !isBlackout
                      ? AppColors.primaryColor.withValues(alpha: 0.6)
                      : Colors.transparent),
            width: isCurrent && !isSelected ? 1.4 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryColor.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              label,
              textAlign: TextAlign.center,
              style: AppStyle.fontSize14Bold(context).copyWith(
                fontSize: 13.sp,
                color: textColor,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            if (isBlackout) ...[
              3.ph,
              Icon(
                Icons.lock_outline_rounded,
                size: 11.sp,
                color: AppColors.greyColor,
              ),
            ] else ...[
              4.ph,
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 14.w : 5.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.primaryColor.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
