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

  /// Brand accent-bar section header with an optional subtitle.
  Widget _sectionHeader(BuildContext context, String title, {String? subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4.w,
          height: subtitle == null ? 24.h : 36.h,
          decoration: BoxDecoration(
            gradient: AppColors.accentGradient,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        10.pw,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                title,
                style: AppStyle.fontSize22Bold(context).copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryColor,
                ),
              ),
              if (subtitle != null) ...[
                2.ph,
                AppText(
                  subtitle,
                  style: AppStyle.fontSize12Regular(context).copyWith(
                    color: AppColors.descContainerColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionDivider() => Divider(
        height: 1,
        thickness: 1,
        color: AppColors.primaryColor.withValues(alpha: 0.08),
      );

  Widget _tapHint(BuildContext context) {
    return Row(
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
            style: AppStyle.fontSize16Regular(context).copyWith(
              fontSize: 13.sp,
              color: AppColors.descContainerColor,
            ),
          ),
        ),
      ],
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

          final hasGallery = (project.data?.media?.isNotEmpty ?? false) ||
              isLoading;

          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero: interactive project map ──────────────────────
                  16.ph,
                  ProjectDetailsImage(
                    controller: controller,
                    isLoading: isLoading,
                    project: project,
                    selectedUnitId: _selectedUnitId,
                    onUnitSelected: _onUnitSelected,
                    onUnmappedSectionTapped: _onUnmappedSectionTapped,
                  ),

                  // ── Section: project info (name + about) ───────────────
                  if (project.data?.name != null) ...[
                    18.ph,
                    AppText(
                      project.data!.name!,
                      style: AppStyle.fontSize22Bold(context).copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                  if ((project.data?.description ?? '').isNotEmpty) ...[
                    12.ph,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: AppText(
                        project.data!.description!,
                        style: AppStyle.fontSize14Regular(context).copyWith(
                          color: AppColors.descContainerColor,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],

                  // ── Section: timeline & events ─────────────────────────
                  if (!isLoading && project.data?.id != null) ...[
                    24.ph,
                    _sectionDivider(),
                    20.ph,
                    _sectionHeader(
                      context,
                      LocaleKeys.project_timeline.tr(),
                      subtitle: LocaleKeys.project_timeline_subtitle.tr(),
                    ),
                    14.ph,
                    if (hasMapping && _selectedUnitId == null) ...[
                      _tapHint(context),
                      12.ph,
                    ],
                    KeyedSubtree(
                      key: _calendarKey,
                      child: ProjectEventsCalendar(
                        projectId: project.data!.id!,
                        unitId: _selectedUnitId,
                        onClearUnit: () =>
                            setState(() => _selectedUnitId = null),
                      ),
                    ),
                  ],

                  // ── Section: gallery ───────────────────────────────────
                  if (hasGallery) ...[
                    24.ph,
                    _sectionDivider(),
                    20.ph,
                    _sectionHeader(context, LocaleKeys.project_gallery.tr()),
                    16.ph,
                    ListViewMainImageForProjectDetails(
                      project: project,
                      isLoading: isLoading,
                    ),
                  ],
                  28.ph,
                ],
              ).paddingSymmetric(horizontal: 16.w),
            ),
          );
        },
      ),
    );
  }
}
