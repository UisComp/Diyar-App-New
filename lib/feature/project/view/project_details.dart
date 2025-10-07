import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/project/controller/project_controller.dart';
import 'package:diyar_app/feature/project/controller/project_state.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
                  InkWell(
                    onTap: () {
                      final projectId = ProjectController.get(
                        context,
                      ).projectDetailsResponseModel.data?.id;

                      if (projectId != null) {
                        context.push(RoutesName.unitEvents, extra: projectId);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: project.data?.mainImage?.url != null
                          ? CustomCachedNetworkImage(
                              imageUrl: project.data?.mainImage?.url,
                              width: double.infinity,
                              height: 250.h,
                            )
                          : Assets.images.projectDetails.image(
                              width: double.infinity,
                              height: 250.h,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                  20.ph,
                  Text(
                    LocaleKeys.master_plan.tr(),
                    style: AppStyle.fontSize22Bold(context),
                  ),
                  10.ph,
                  if (project.data?.name != null)
                    Text(
                      project.data!.name!,
                      style: AppStyle.fontSize16Regular(
                        context,
                      ).copyWith(color: AppColors.greyColor),
                    ),
                  20.ph,
                  Text(
                    LocaleKeys.master_plan.tr(),
                    style: AppStyle.fontSize18Bold(context),
                  ),
                  20.ph,
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        project.data?.media?.length ?? (isLoading ? 4 : 0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.w,
                      childAspectRatio: .95,
                    ),
                    itemBuilder: (context, index) {
                      final imageUrl = project.data?.media?[index].url;
                      return Card(
                        color: AppColors.whiteColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: imageUrl != null
                              ? CustomCachedNetworkImage(
                                  imageUrl: imageUrl,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Assets.images.diyarPmc.image(
                                  width: 80.w,
                                  height: 70.h,
                                ),
                        ),
                      );
                    },
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
