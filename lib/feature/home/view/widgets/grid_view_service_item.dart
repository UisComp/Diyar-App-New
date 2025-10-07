import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class GridViewServiceItem extends StatelessWidget {
  const GridViewServiceItem({
    super.key,
    required this.cardColor,
    required this.cardImageColor,
    required this.textColor,
    required this.index,
  });

  final Color cardColor;
  final Color cardImageColor;
  final Color textColor;
  final int index;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeController, HomeState>(
      builder: (context, state) {
        final homeController = HomeController.get(context);
        final service = homeController.userServicesResponse.data?[index];
        final type = service?.type;

        return InkWell(
          onTap: () {
            final screenName = getScreenNameByType(type);
            if (screenName != null) {
              context.push(screenName, extra: service);
            } else {
              AppFunctions.errorMessage(
                context,
                message: "This service is not available yet",
              );
            }
          },
          child: Card(
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            elevation: 2,
            child: Column(
              children: [
                Expanded(
                  flex: 7,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: cardImageColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.r),
                      ),
                    ),
                    child: CustomCachedNetworkImage(
                      imageUrl: service?.icon?.url,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      service?.name ?? 'Unknown',
                      style: AppStyle.fontSize16Regular(
                        context,
                      ).copyWith(color: textColor, fontSize: 14.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
