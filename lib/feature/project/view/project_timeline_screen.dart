import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/project/controller/project_controller.dart';
import 'package:diyar_app/feature/project/controller/project_state.dart';
import 'package:diyar_app/feature/project/model/projects_response_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Entry point for the "Project Timeline" home feature.
///
/// Resolves the authenticated user's project(s):
/// - exactly one project  -> opens its details directly (replacing this screen),
/// - multiple projects     -> shows a quick chooser,
/// - none                  -> shows an empty state.
class ProjectTimelineScreen extends StatefulWidget {
  const ProjectTimelineScreen({super.key});

  @override
  State<ProjectTimelineScreen> createState() => _ProjectTimelineScreenState();
}

class _ProjectTimelineScreenState extends State<ProjectTimelineScreen> {
  bool _navigated = false;

  void _openProject(BuildContext context, int id, {bool replace = false}) {
    if (replace) {
      context.pushReplacement(
        RoutesName.projectDetails,
        extra: id.toString(),
      );
    } else {
      context.push(RoutesName.projectDetails, extra: id.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.project_timeline.tr()),
      body: BlocConsumer<ProjectController, ProjectState>(
        listener: (context, state) {
          if (state is GetUserProjectsSuccessfullyState && !_navigated) {
            final projects =
                ProjectController.get(context).projectsResponseModel.data ?? [];
            if (projects.length == 1 && projects.first.id != null) {
              _navigated = true;
              _openProject(context, projects.first.id!, replace: true);
            }
          }
        },
        builder: (context, state) {
          final controller = ProjectController.get(context);
          final projects = controller.projectsResponseModel.data ?? [];
          final isLoading =
              state is GetUserProjectsLoadingState ||
              state is ProjectInitialState;

          if (isLoading || (projects.length == 1 && _navigated)) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }

          if (projects.isEmpty) {
            return Center(
              child: AppText(
                LocaleKeys.no_projects_found.tr(),
                style: AppStyle.fontSize16Regular(
                  context,
                ).copyWith(color: AppColors.primaryColor),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4.w,
                      height: 26.h,
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    10.pw,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          LocaleKeys.select_project.tr(),
                          style: AppStyle.fontSize22Bold(context).copyWith(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        AppText(
                          '${projects.length} ${LocaleKeys.projects.tr()}',
                          style: AppStyle.fontSize12Regular(context).copyWith(
                            color: AppColors.descContainerColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                20.ph,
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: projects.length,
                  separatorBuilder: (_, _) => 16.ph,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return _ProjectCard(
                      project: project,
                      onTap: () {
                        if (project.id != null) {
                          _openProject(context, project.id!);
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Premium project card: an image banner with the project name overlaid on a
/// gradient scrim, plus a "View timeline" call-to-action footer.
class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project, required this.onTap});

  final Project project;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Material(
          color: AppColors.whiteColor,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _banner(context),
                _ctaFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _banner(BuildContext context) {
    return Stack(
      children: [
        CustomCachedNetworkImage(
          imageUrl: project.mainImage?.url,
          width: double.infinity,
          height: 150.h,
          fit: BoxFit.cover,
          isProjectDetails: true,
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  AppColors.blackColor.withValues(alpha: 0.65),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 16.w,
          right: 16.w,
          bottom: 12.h,
          child: AppText(
            project.name ?? '',
            style: TextStyle(
              color: AppColors.whiteColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
              shadows: const [
                Shadow(color: Colors.black54, blurRadius: 6),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _ctaFooter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(
            Icons.timeline_rounded,
            size: 18.sp,
            color: AppColors.primaryColor,
          ),
          8.pw,
          Expanded(
            child: AppText(
              LocaleKeys.view_timeline.tr(),
              style: AppStyle.fontSize14Bold(
                context,
              ).copyWith(color: AppColors.primaryColor),
            ),
          ),
          Container(
            height: 32.w,
            width: 32.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.sp,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
    );
  }
}
