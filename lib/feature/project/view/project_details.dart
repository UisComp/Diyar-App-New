import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/auth/helper/auth_session.dart';
import 'package:diyar_app/feature/project/controller/project_controller.dart';
import 'package:diyar_app/feature/project/controller/project_state.dart';
import 'package:diyar_app/feature/project/view/widgets/list_view_main_image_for_project_details.dart';
import 'package:diyar_app/feature/project/model/project_details_response_model.dart';
import 'package:diyar_app/feature/project/view/widgets/building_units_sheet.dart';
import 'package:diyar_app/feature/project/view/widgets/master_plan_map.dart';
import 'package:diyar_app/feature/project/view/widgets/my_units_overview.dart';
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
  /// The unit whose news the timeline shows (null = whole project).
  UnitSummary? _selectedUnit;
  Building? _selectedBuilding;
  final GlobalKey _calendarKey = GlobalKey();

  void _selectUnit(Building building, UnitSummary unit) {
    setState(() {
      _selectedBuilding = building;
      _selectedUnit = unit;
    });
    // Bring the timeline, now scoped to the unit, into view.
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

  void _clearUnit() => setState(() {
    _selectedUnit = null;
    _selectedBuilding = null;
  });

  /// Shows the user's units in [building] in full (all of them, or just
  /// [unit]). Only the owner gets buildings from the API, so the news button
  /// is always theirs to use.
  void _openBuilding(Building building, [UnitSummary? unit]) {
    BuildingUnitsSheet.show(
      context,
      building,
      units: unit == null ? null : [unit],
      onViewNews: (unit) {
        Navigator.of(context).pop();
        _selectUnit(building, unit);
      },
    );
  }

  Future<void> _openFullScreenMap(ProjectData project) async {
    final building = await MasterPlanFullScreen.open(
      context,
      project,
      selectedBuildingId: _selectedBuilding?.id,
    );
    if (building != null && mounted) _openBuilding(building);
  }

  /// Brand accent-bar section header with an optional subtitle.
  Widget _sectionHeader(
    BuildContext context,
    String title, {
    String? subtitle,
  }) {
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
                  style: AppStyle.fontSize12Regular(
                    context,
                  ).copyWith(color: AppColors.descContainerColor),
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
            LocaleKeys.tap_your_building_to_view_units.tr(),
            style: AppStyle.fontSize16Regular(
              context,
            ).copyWith(fontSize: 13.sp, color: AppColors.descContainerColor),
          ),
        ),
      ],
    );
  }

  /// Why there's no "My units" list: signed out, or nothing owned here.
  Widget _noUnitsNote(BuildContext context) {
    final signedIn = AuthSession.isLoggedIn;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(
            signedIn ? Icons.info_outline_rounded : Icons.lock_outline_rounded,
            size: 20.sp,
            color: AppColors.primaryColor,
          ),
          10.pw,
          Expanded(
            child: AppText(
              signedIn
                  ? LocaleKeys.no_units_in_project.tr()
                  : LocaleKeys.sign_in_to_see_your_units.tr(),
              style: AppStyle.fontSize14Regular(
                context,
              ).copyWith(color: AppColors.descContainerColor, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _masterPlan(ProjectData project) {
    return Stack(
      children: [
        MasterPlanMap(
          project: project,
          selectedBuildingId: _selectedBuilding?.id,
          onBuildingTapped: _openBuilding,
        ),
        PositionedDirectional(
          top: 8.h,
          end: 8.w,
          child: Material(
            color: AppColors.blackColor.withValues(alpha: 0.55),
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: LocaleKeys.master_plan.tr(),
              onPressed: () => _openFullScreenMap(project),
              icon: const Icon(
                Icons.fullscreen_rounded,
                color: AppColors.whiteColor,
              ),
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
          final project = controller.projectDetailsResponseModel.data;
          final hasMap =
              project != null &&
              ((project.mainImage?.url?.isNotEmpty ?? false) ||
                  project.linkedShapes.isNotEmpty);
          final hasLinkedShapes = project?.linkedShapes.isNotEmpty ?? false;
          // Only the user's own buildings (empty when signed out).
          final buildings = project?.buildings ?? const <Building>[];
          final ownsUnits = buildings.any((b) => b.units.isNotEmpty);
          final hasGallery =
              (project?.gallery.isNotEmpty ?? false) || isLoading;

          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Hero: the master plan with its buildings ───────────
                  16.ph,
                  if (isLoading)
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.greyColor.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                    )
                  else if (hasMap) ...[
                    _masterPlan(project),
                    if (hasLinkedShapes) ...[
                      10.ph,
                      const MasterPlanLegend(),
                      if (_selectedUnit == null) ...[10.ph, _tapHint(context)],
                    ],
                  ],

                  // ── Section: project info (name + about) ───────────────
                  if (project?.name != null) ...[
                    18.ph,
                    AppText(
                      project!.name!,
                      style: AppStyle.fontSize22Bold(
                        context,
                      ).copyWith(fontSize: 20.sp, fontWeight: FontWeight.w800),
                    ),
                  ],
                  if ((project?.description ?? '').isNotEmpty) ...[
                    12.ph,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: AppText(
                        project!.description!,
                        style: AppStyle.fontSize14Regular(context).copyWith(
                          color: AppColors.descContainerColor,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],

                  // ── Section: the user's own units ──────────────────────
                  if (!isLoading && project != null) ...[
                    24.ph,
                    _sectionDivider(),
                    20.ph,
                    _sectionHeader(context, LocaleKeys.my_units.tr()),
                    14.ph,
                    if (ownsUnits)
                      MyUnitsOverview(
                        buildings: buildings,
                        selectedUnitId: _selectedUnit?.id,
                        onUnitTapped: _openBuilding,
                      )
                    else
                      _noUnitsNote(context),
                  ],

                  // ── Section: timeline & events ─────────────────────────
                  // News is owner-only, so there's nothing to show unless
                  // the user owns a unit here.
                  if (!isLoading && project?.id != null && ownsUnits) ...[
                    24.ph,
                    _sectionDivider(),
                    20.ph,
                    _sectionHeader(
                      context,
                      LocaleKeys.project_timeline.tr(),
                      subtitle: LocaleKeys.project_timeline_subtitle.tr(),
                    ),
                    14.ph,
                    KeyedSubtree(
                      key: _calendarKey,
                      child: ProjectEventsCalendar(
                        projectId: project!.id!,
                        unitId: _selectedUnit?.id,
                        unitLabel: _selectedUnit?.label,
                        onClearUnit: _clearUnit,
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
                      project: controller.projectDetailsResponseModel,
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
