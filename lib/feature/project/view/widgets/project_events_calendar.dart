import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/app_formatter.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/feature/project/view/widgets/month_timeline_selector.dart';
import 'package:diyar_app/feature/unit_event/controller/unit_event_controller.dart';
import 'package:diyar_app/feature/unit_event/controller/unit_event_state.dart';
import 'package:diyar_app/feature/unit_event/view/widgets/build_shimmer_item.dart';
import 'package:diyar_app/feature/unit_event/view/widgets/empty_unit_event.dart';
import 'package:diyar_app/feature/unit_event/view/widgets/event_item.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Month timeline shown directly under the project image. Months of the
/// selected year can be multi-selected (future months are blacked out) and the
/// year can be changed. The selected span is sent to the backend as a
/// [start]/[end] date range:
///  * when [unitId] is set -> news for that unit only,
///  * otherwise            -> news for the whole project.
class ProjectEventsCalendar extends StatefulWidget {
  const ProjectEventsCalendar({
    super.key,
    required this.projectId,
    this.unitId,
    this.onClearUnit,
  });

  final int projectId;

  /// When non-null the timeline is scoped to this unit; null means the whole
  /// project.
  final int? unitId;

  /// Invoked when the user clears the unit filter to go back to project scope.
  final VoidCallback? onClearUnit;

  @override
  State<ProjectEventsCalendar> createState() => _ProjectEventsCalendarState();
}

class _ProjectEventsCalendarState extends State<ProjectEventsCalendar> {
  late UnitEventController _controller;

  /// Today's year/month, used to blackout months that have not arrived and to
  /// cap forward year navigation.
  late int _currentYear;
  late int _currentMonth;

  /// Year currently shown by the timeline.
  late int _year;

  /// Currently selected months (1-based indices) within [_year].
  final Set<int> _selectedMonths = {};

  /// How far back the user can navigate.
  static const int _yearsBack = 10;

  @override
  void initState() {
    super.initState();
    _controller = UnitEventController.get(context);
    final now = DateTime.now();
    _currentYear = now.year;
    _currentMonth = now.month;
    _year = _currentYear;
    _resetToDefaultSelection();
    _fetchSelectedRange();
  }

  @override
  void didUpdateWidget(covariant ProjectEventsCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Switching project resets everything; switching scope (unit<->project)
    // keeps the chosen months and just reloads the new scope.
    if (oldWidget.projectId != widget.projectId) {
      _year = _currentYear;
      _resetToDefaultSelection();
      _fetchSelectedRange();
    } else if (oldWidget.unitId != widget.unitId) {
      _fetchSelectedRange();
    }
  }

  /// Highest selectable month for [_year] (current month for the current year,
  /// otherwise the full year is available).
  int get _lastAvailableMonth => _year < _currentYear ? 12 : _currentMonth;

  /// By default every month of the year that has already arrived is selected.
  void _resetToDefaultSelection() {
    _selectedMonths
      ..clear()
      ..addAll(List.generate(_lastAvailableMonth, (i) => i + 1));
  }

  void _onMonthTapped(int month) {
    setState(() {
      if (_selectedMonths.contains(month)) {
        // Keep at least one month selected so the range stays valid.
        if (_selectedMonths.length > 1) _selectedMonths.remove(month);
      } else {
        _selectedMonths.add(month);
      }
    });
    _fetchSelectedRange();
  }

  void _changeYear(int delta) {
    final target = _year + delta;
    if (target < _currentYear - _yearsBack || target > _currentYear) return;
    setState(() {
      _year = target;
      _resetToDefaultSelection();
    });
    _fetchSelectedRange();
  }

  /// First day of the earliest selected month.
  DateTime get _rangeStart =>
      DateTime(_year, _selectedMonths.reduce((a, b) => a < b ? a : b), 1);

  /// Last day of the latest selected month.
  DateTime get _rangeEnd {
    final lastMonth = _selectedMonths.reduce((a, b) => a > b ? a : b);
    return DateTime(_year, lastMonth + 1, 0);
  }

  /// Sends the selected month span to the backend, scoped to the unit when one
  /// is selected or the whole project otherwise.
  Future<void> _fetchSelectedRange() {
    if (_selectedMonths.isEmpty) return Future.value();
    if (widget.unitId != null) {
      return _controller.getUnitsByEvent(
        id: widget.unitId.toString(),
        start: _rangeStart,
        end: _rangeEnd,
      );
    }
    return _controller.getProjectNewsByEvent(
      id: widget.projectId.toString(),
      start: _rangeStart,
      end: _rangeEnd,
    );
  }

  String get _selectionSummary {
    final months = _selectedMonths.toList()..sort();
    final startLabel =
        AppFormatter.monthYearFormatter().format(DateTime(_year, months.first));
    if (months.length == 1) return startLabel;
    final endLabel =
        AppFormatter.monthYearFormatter().format(DateTime(_year, months.last));
    return '$startLabel  -  $endLabel';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnitEventController, UnitEventStates>(
      builder: (context, state) {
        final items =
            _controller.newByProjectUnitEventResponseModel.data ?? [];
        final isLoading = state is GetUnitsByEventLoadingState;
        final isEmpty = !isLoading && items.isEmpty;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _timelineCard(context, isLoading),
            12.ph,
            _scopeBar(context),
            16.ph,
            isEmpty
                ? const EmptyUnitEvent()
                : ListView.separated(
                    separatorBuilder: (context, index) => 10.ph,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: isLoading ? 3 : items.length,
                    itemBuilder: (context, index) {
                      if (isLoading) {
                        return const BuildShimmerItem();
                      }
                      final news = items[index];
                      return EventItem(
                        newsId: news.id ?? 0,
                        title: news.title ?? '',
                        description: news.content ?? '',
                        imageUrl: news.media?.isNotEmpty == true
                            ? news.media![0].url ?? ''
                            : '',
                      );
                    },
                  ),
          ],
        );
      },
    );
  }

  Widget _timelineCard(BuildContext context, bool isLoading) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
      child: MonthTimelineSelector(
        year: _year,
        selectedMonths: _selectedMonths,
        lastAvailableMonth: _lastAvailableMonth,
        enabled: !isLoading,
        onMonthTapped: _onMonthTapped,
        onPrevYear: _year > _currentYear - _yearsBack
            ? () => _changeYear(-1)
            : null,
        onNextYear: _year < _currentYear ? () => _changeYear(1) : null,
      ),
    );
  }

  Widget _scopeBar(BuildContext context) {
    final isUnitScope = widget.unitId != null;
    return Row(
      children: [
        Icon(
          isUnitScope
              ? Icons.location_on_outlined
              : Icons.event_available_outlined,
          size: 18.sp,
          color: AppColors.primaryColor,
        ),
        8.pw,
        Expanded(
          child: AppText(
            '${(isUnitScope ? LocaleKeys.showing_selected_unit : LocaleKeys.showing_all_project_news).tr()}'
            '  •  $_selectionSummary',
            style: AppStyle.fontSize14Bold(
              context,
            ).copyWith(fontSize: 13.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isUnitScope && widget.onClearUnit != null) ...[
          8.pw,
          GestureDetector(
            onTap: widget.onClearUnit,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.close_rounded,
                    size: 14.sp,
                    color: AppColors.primaryColor,
                  ),
                  4.pw,
                  AppText(
                    LocaleKeys.clear.tr(),
                    style: AppStyle.fontSize12Bold(
                      context,
                    ).copyWith(color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
