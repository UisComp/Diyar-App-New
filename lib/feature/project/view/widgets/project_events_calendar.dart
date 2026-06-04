import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/feature/unit_event/controller/unit_event_controller.dart';
import 'package:diyar_app/feature/unit_event/controller/unit_event_state.dart';
import 'package:diyar_app/feature/unit_event/view/widgets/build_shimmer_item.dart';
import 'package:diyar_app/feature/unit_event/view/widgets/empty_unit_event.dart';
import 'package:diyar_app/feature/unit_event/view/widgets/event_item.dart';
import 'package:diyar_app/feature/unit_event/view/widgets/selected_date_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

/// Inline calendar shown under the project image once a mapped unit/section
/// is tapped. It lists that unit's events for the selected month range using
/// the shared [UnitEventController].
class ProjectEventsCalendar extends StatefulWidget {
  const ProjectEventsCalendar({super.key, required this.unitId});

  final int unitId;

  @override
  State<ProjectEventsCalendar> createState() => _ProjectEventsCalendarState();
}

class _ProjectEventsCalendarState extends State<ProjectEventsCalendar> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late UnitEventController _controller;

  @override
  void initState() {
    super.initState();
    _controller = UnitEventController.get(context);
    _focusedDay = DateTime.now();
    if (_focusedDay.isAfter(DateTime.utc(2030, 12, 31))) {
      _focusedDay = DateTime.utc(2030, 12, 31);
    }
    _loadMonth(_focusedDay);
  }

  @override
  void didUpdateWidget(covariant ProjectEventsCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A different section was tapped -> reset the range and reload its events.
    if (oldWidget.unitId != widget.unitId) {
      _rangeStart = null;
      _rangeEnd = null;
      _loadMonth(_focusedDay);
    }
  }

  DateTime _monthStart(DateTime d) => DateTime(d.year, d.month, 1);
  DateTime _monthEnd(DateTime d) => DateTime(d.year, d.month + 1, 0);

  Future<void> _loadMonth(DateTime month) {
    return _controller.getUnitsByEvent(
      id: widget.unitId.toString(),
      start: _monthStart(month),
      end: _monthEnd(month),
    );
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
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: AppColors.primaryColor.withValues(alpha: 0.12),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: TableCalendar(
                firstDay: DateTime.utc(2000, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: RangeSelectionMode.enforced,
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                onRangeSelected: isLoading
                    ? null
                    : (start, end, focusedDay) async {
                        setState(() {
                          _rangeStart = start;
                          _rangeEnd = end;
                          _focusedDay = focusedDay;
                        });
                        await _controller.getUnitsByEvent(
                          id: widget.unitId.toString(),
                          start: start,
                          end: end ?? start,
                        );
                      },
                onPageChanged: isLoading
                    ? null
                    : (focusedDay) {
                        setState(() {
                          _focusedDay = focusedDay;
                          _rangeStart = null;
                          _rangeEnd = null;
                        });
                        _loadMonth(focusedDay);
                      },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  rangeStartDecoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  rangeEndDecoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  rangeHighlightColor: AppColors.primaryColor.withValues(
                    alpha: 0.12,
                  ),
                  withinRangeDecoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: const TextStyle(color: AppColors.whiteColor),
                  defaultTextStyle: const TextStyle(
                    color: AppColors.blackColor,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: AppColors.blackColor),
                  weekendStyle: TextStyle(color: AppColors.blackColor),
                ),
              ),
            ),
            16.ph,
            if (_rangeStart != null)
              SelectedDateInfo(rangeStart: _rangeStart, rangeEnd: _rangeEnd),
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
}
