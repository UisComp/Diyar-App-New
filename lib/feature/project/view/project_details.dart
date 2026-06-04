import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/project/controller/project_controller.dart';
import 'package:diyar_app/feature/project/controller/project_state.dart';
import 'package:diyar_app/feature/project/view/widgets/list_view_main_image_for_project_details.dart';
import 'package:diyar_app/feature/project/view/widgets/project_details_image.dart';
import 'package:diyar_app/feature/project/view/widgets/project_events_calendar.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProjectDetails extends StatefulWidget {
  const ProjectDetails({super.key});

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  int? _selectedUnitId;
  final GlobalKey _calendarKey = GlobalKey();

  void _onUnitSelected(int unitId) {
    setState(() => _selectedUnitId = unitId);
    // Bring the freshly revealed calendar into view.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _calendarKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.05,
        );
      }
    });
  }

  void _onUnmappedSectionTapped() {
    AppFunctions.warningMessage(
      context,
      message: LocaleKeys.no_events_or_mapped_units_here.tr(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.project_timeline.tr()),
      body: BlocBuilder<ProjectController, ProjectState>(
        builder: (context, state) {
          final controller = ProjectController.get(context);
          final isLoading = state is GetProjectDetailsLoadingState;
          final project = controller.projectDetailsResponseModel;
          final hasMapping =
              project.data?.unitMapping != null &&
              (project.data?.unitMapping?.shapes?.isNotEmpty ?? false);

          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.ph,
                  ProjectDetailsImage(
                    controller: controller,
                    isLoading: isLoading,
                    project: project,
                    selectedUnitId: _selectedUnitId,
                    onUnitSelected: _onUnitSelected,
                    onUnmappedSectionTapped: _onUnmappedSectionTapped,
                  ),
                  if (!isLoading && hasMapping) ...[
                    12.ph,
                    if (_selectedUnitId == null)
                      Row(
                        children: [
                          Icon(
                            Icons.touch_app_outlined,
                            size: 18.sp,
                            color: AppColors.primaryColor,
                          ),
                          8.pw,
                          Expanded(
                            child: AppText(
                              LocaleKeys.tap_section_to_view_events.tr(),
                              style: AppStyle.fontSize16Regular(context)
                                  .copyWith(
                                    fontSize: 13.sp,
                                    color: AppColors.descContainerColor,
                                  ),
                            ),
                          ),
                        ],
                      )
                    else
                      Padding(
                        key: _calendarKey,
                        padding: EdgeInsets.only(top: 8.h),
                        child: ProjectEventsCalendar(unitId: _selectedUnitId!),
                      ),
                  ],
                  20.ph,
                  if (project.data?.name != null)
                    AppText(
                      project.data!.name!,
                      style: AppStyle.fontSize22Bold(
                        context,
                      ).copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                  if (project.data?.description != null)
                    AppText(
                      project.data!.description ?? '',
                      style: AppStyle.fontSize16Regular(
                        context,
                      ).copyWith(fontWeight: FontWeight.w400),
                    ),
                  20.ph,
                  AppText(
                    LocaleKeys.project_gallery.tr(),
                    style: AppStyle.fontSize18Bold(context),
                  ),
                  20.ph,
                  ListViewMainImageForProjectDetails(
                    project: project,
                    isLoading: isLoading,
                  ),
                  20.ph,
                ],
              ).paddingSymmetric(horizontal: 16.w),
            ),
          );
        },
      ),
    );
  }
}
