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
    homeController.searchController.addListener(() {
      homeController.filterServices();
    });
  }

  @override
  void dispose() {
    homeController.searchController.removeListener(() {});
    super.dispose();
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
          // final homeController = HomeController.get(context);
          // final isLoading = state is GetAllServicesLoadingState;
          // final services = homeController.filteredServices.isNotEmpty ||
          //         homeController.searchController.text.isNotEmpty
          //     ? homeController.filteredServices
          //     : (homeController.userServicesResponse.data ?? []);
          final homeController = HomeController.get(context);
          final isLoading = state is GetAllServicesLoadingState;
          final searchText = homeController.searchController.text.trim();

          final allServices =
              homeController.filteredServices.isNotEmpty ||
                  searchText.isNotEmpty
              ? homeController.filteredServices
              : (homeController.userServicesResponse.data ?? []);
          final services = allServices
              .where((service) => service.isActive == true)
              .toList();

          if (!isLoading && searchText.isNotEmpty && services.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Center(
                child: Text(
                  LocaleKeys.no_results_found.tr(),
                  style: AppStyle.fontSize16Regular(context).copyWith(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }

          return Skeletonizer(
            enabled: isLoading,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: homeController.searchController,
                        hintStyle: AppStyle.fontSize16Regular(context),
                        hintText: LocaleKeys.search_services.tr(),
                        prefixIcon: SvgPicture.asset(
                          Assets.images.svg.search,
                          height: 24.h,
                          width: 24.w,
                          fit: BoxFit.scaleDown,
                        ),
                      ).paddingOnly(top: 15.h, left: 16.w, right: 16.w),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(16.sp),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (isLoading || services.isEmpty) {
                        return GridViewServiceItem(
                          cardColor: cardColor,
                          cardImageColor: cardImageColor,
                          textColor: textColor,
                          service: null,
                        );
                      }

                      final service = services[index];
                      return GridViewServiceItem(
                        service: service,
                        cardColor: cardColor,
                        cardImageColor: cardImageColor,
                        textColor: textColor,
                      );
                    }, childCount: isLoading ? 8 : (services.length)),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 1,
                    ),
                  ),
                ),

                if (!isLoading && services.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: Center(
                        child: Text(
                          LocaleKeys.no_results_found.tr(),
                          style: AppStyle.fontSize16Regular(
                            context,
                          ).copyWith(color: AppColors.primaryColor),
                        ),
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
