import 'package:diyar_app/core/extension/sized_box.dart'; // Assuming this provides custom SizedBox extensions
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class UnitEvent extends StatefulWidget {
  const UnitEvent({super.key});

  @override
  UnitEventState createState() => UnitEventState();
}

class UnitEventState extends State<UnitEvent> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now(); 
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    if (_focusedDay.isAfter(DateTime.utc(2025, 12, 31))) {
      _focusedDay = DateTime.utc(2025, 12, 31);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.unit_events.tr()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar
              TableCalendar(
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                  });
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
                  defaultTextStyle: TextStyle(color: Colors.black),
                  weekendTextStyle: TextStyle(color: Colors.black),
                  todayTextStyle: TextStyle(color: Colors.white),
                  selectedTextStyle: TextStyle(color: Colors.white),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.black),
                  weekendStyle: TextStyle(color: Colors.black),
                ),
              ),
              20.ph,

              Text(
                'October 20, 2024',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              10.ph,
              Text(
                '10:00 AM',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              EventItem(
                title: 'News 1',
                description:
                    'Join us for a fun-filled community gathering with games, food, and music',
                imageUrl: Assets.images.diyarNativeSplash.path,
              ),
              10.ph,

              Text(
                '10:00 AM',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              EventItem(
                title: 'News 2',
                description:
                    'Discuss property management updates and future plans',
                imageUrl: Assets.images.diyarNativeSplash.path,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const EventItem({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(RoutesName.newsScreen);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Spacer(),
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(8.r)),
              child: Image.asset(
                imageUrl,
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
