
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/project/model/project_details_response_model.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListViewMainImageForProjectDetails extends StatelessWidget {
  const ListViewMainImageForProjectDetails({
    super.key,
    required this.project,
    required this.isLoading,
  });

  final ProjectDetailsResponseModel project;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
            child: isLoading
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey.shade300,
                  )
                : (imageUrl != null
                      ? CustomCachedNetworkImage(
                          imageUrl: imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      : Assets.images.diyarPmc.image(
                          width: 80.w,
                          height: 70.h,
                        )),
          ),
        );
      },
    );
  }
}
