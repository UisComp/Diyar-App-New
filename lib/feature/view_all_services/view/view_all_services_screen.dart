import 'package:diyar_app/core/cubits/app_theme/app_theme_controller.dart';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:diyar_app/feature/home/view/widgets/grid_view_service_item.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ViewAllServicesScreen extends StatefulWidget {
  const ViewAllServicesScreen({super.key});

  @override
  State<ViewAllServicesScreen> createState() => _ViewAllServicesScreenState();
}

class _ViewAllServicesScreenState extends State<ViewAllServicesScreen> {
  late HomeController homeController;

  @override
  void initState() {
    super.initState();
    homeController = HomeController.get(context);
    homeController.getAllServices();
  }

  @override
  Widget build(BuildContext context) {
    final darkTheme =
        AppThemeController.get(context).currentThemeMode == AppThemeMode.dark;
    final cardColor = darkTheme ? AppColors.black87 : AppColors.whiteColor;
    final cardImageColor = darkTheme
        ? AppColors.black87
        : AppColors.secondaryColor;
    final textColor = darkTheme ? AppColors.containerColor : AppColors.black87;

    return Scaffold(
      appBar: CustomAppBar(
        titleAppBar: LocaleKeys.diyar.tr(),
        showIconNotification: true,
      ),
      body: BlocBuilder<HomeController, HomeState>(
        builder: (context, state) {
          final homeController = HomeController.get(context);
          final isLoading = state is GetAllServicesLoadingState;
          return Skeletonizer(
            enabled: isLoading,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      CustomTextFormField(
                        hintStyle: AppStyle.fontSize16Regular(context),
                        hintText: LocaleKeys.search_services.tr(),
                        prefixIcon: SvgPicture.asset(
                          Assets.images.svg.search,
                          height: 24.h,
                          width: 24.w,
                          fit: BoxFit.scaleDown,
                        ),
                      ).paddingOnly(top: 15.h),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(16.sp),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return GridViewServiceItem(
                          index: index,
                          cardColor: cardColor,
                          cardImageColor: cardImageColor,
                          textColor: textColor,
                        );
                      },
                      childCount: isLoading
                          ? 8 // number of skeleton items while loading
                          : (homeController.userServicesResponse.data?.length ??
                                0),
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 1,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
