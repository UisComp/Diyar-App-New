import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/unit_event/controller/unit_event_state.dart';
import 'package:diyar_app/feature/unit_event/view/widgets/build_shimmer_item.dart';
import 'package:diyar_app/feature/unit_event/view/widgets/empty_unit_event.dart';
import 'package:diyar_app/feature/unit_event/view/widgets/event_item.dart';
import 'package:diyar_app/feature/unit_event/view/widgets/selected_date_info.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controller/unit_event_controller.dart';

class UnitEvent extends StatefulWidget {
  const UnitEvent({super.key, required this.projectId});
  final int projectId;
  @override
  UnitEventState createState() => UnitEventState();
}

class UnitEventState extends State<UnitEvent> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? rangeStart;
  DateTime? rangeEnd;
  late UnitEventController unitEventController;

  @override
  void initState() {
    super.initState();
    unitEventController = UnitEventController.get(context);
    if (_focusedDay.isAfter(DateTime.utc(2025, 12, 31))) {
      _focusedDay = DateTime.utc(2025, 12, 31);
    }
    unitEventController.getUnitsByEvent(
      id: widget.projectId.toString(),
      start: _focusedDay,
      end: _focusedDay,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.unit_events.tr()),
      body: BlocConsumer<UnitEventController, UnitEventStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final items =
              unitEventController.newByProjectUnitEventResponseModel.data ?? [];
          final isLoading = state is GetUnitsByEventLoadingState;
          final isEmpty = !isLoading && items.isEmpty;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2000, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: calendarFormat,
                    rangeSelectionMode: RangeSelectionMode.enforced,
                    rangeStartDay: rangeStart,
                    rangeEndDay: rangeEnd,
                    onRangeSelected: state is GetUnitsByEventLoadingState
                        ? null
                        : (start, end, focusedDay) async {
                            setState(() {
                              rangeStart = start;
                              rangeEnd = end;
                              _focusedDay = focusedDay;
                            });
                            await unitEventController.getUnitsByEvent(
                              id: widget.projectId.toString(),
                              start: start,
                              end: end ?? start,
                            );
                          },
                    onPageChanged: state is GetUnitsByEventLoadingState
                        ? null
                        : (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.brown[300],
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.brown[600],
                        shape: BoxShape.circle,
                      ),
                      rangeStartDecoration: BoxDecoration(
                        color: Colors.brown[600],
                        shape: BoxShape.circle,
                      ),
                      rangeEndDecoration: BoxDecoration(
                        color: Colors.brown[600],
                        shape: BoxShape.circle,
                      ),
                      withinRangeDecoration: BoxDecoration(
                        color: Colors.brown[200],
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: const TextStyle(color: Colors.white),
                      defaultTextStyle: const TextStyle(color: Colors.black),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(color: AppColors.blackColor),
                      weekendStyle: TextStyle(color: AppColors.blackColor),
                    ),
                  ),

                  20.ph,
                  if (rangeStart != null)
                    SelectedDateInfo(
                      rangeStart: rangeStart,
                      rangeEnd: rangeEnd,
                    ),
                  20.ph,
                  Skeletonizer(
                    enabled: isLoading,
                    child: isEmpty
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
                  ),
                  10.ph,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
