import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/project/controller/project_controller.dart';
import 'package:diyar_app/feature/project/controller/project_state.dart';
import 'package:diyar_app/feature/project/view/widgets/list_view_main_image_for_project_details.dart';
import 'package:diyar_app/feature/project/view/widgets/project_details_image.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProjectDetails extends StatelessWidget {
  const ProjectDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.project_details.tr()),
      body: BlocBuilder<ProjectController, ProjectState>(
        builder: (context, state) {
          final controller = ProjectController.get(context);
          final isLoading = state is GetProjectDetailsLoadingState;
          final project = controller.projectDetailsResponseModel;
          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.ph,
                  ProjectDetailsImage(controller: controller, isLoading: isLoading, project: project),
                  20.ph,
                  if (project.data?.name != null)
                    Text(
                      project.data!.name!,
                      style: AppStyle.fontSize22Bold(
                        context,
                      ).copyWith(fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                  if (project.data?.description != null)
                    Text(
                      project.data!.description ?? '',
                      style: AppStyle.fontSize16Regular(
                        context,
                      ).copyWith(fontWeight: FontWeight.w400),
                    ),
                  20.ph,
                  Text(
                    LocaleKeys.project_gallery.tr(),
                    style: AppStyle.fontSize18Bold(context),
                  ),
                  20.ph,
                  ListViewMainImageForProjectDetails(project: project, isLoading: isLoading),
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
