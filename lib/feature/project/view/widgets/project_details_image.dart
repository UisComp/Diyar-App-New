
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/project/controller/project_controller.dart';
import 'package:diyar_app/feature/project/model/project_details_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ProjectDetailsImage extends StatelessWidget {
  const ProjectDetailsImage({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.project,
  });

  final ProjectController controller;
  final bool isLoading;
  final ProjectDetailsResponseModel project;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final projectId =
            controller.projectDetailsResponseModel.data?.id;
    
        if (projectId != null) {
          context.push(RoutesName.unitEvents, extra: projectId);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: isLoading
            ? Container(
                width: double.infinity,
                height: 250.h,
                color: Colors.grey.shade300,
              )
            : CustomCachedNetworkImage(
                isProjectDetails: true,
                imageUrl: project.data?.mainImage?.url,
                width: double.infinity,
                height: 250.h,
              ),
      ),
    );
  }
}
