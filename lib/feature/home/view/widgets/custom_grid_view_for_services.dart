import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:diyar_app/feature/home/view/widgets/grid_view_service_item.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomGridViewForServices extends StatelessWidget {
  const CustomGridViewForServices({
    super.key,
    required this.cardColor,
    required this.cardImageColor,
    required this.textColor,
  });

  final Color cardColor;
  final Color cardImageColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
      return BlocConsumer<HomeController, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
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
            return const NoServiceFound();
          }

          return Skeletonizer(
            enabled: isLoading,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: isLoading ? 5 : services.take(5).length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: .95,
              ),
              itemBuilder: (context, index) {
                if (!isLoading && index >= services.length) {
                  return const SizedBox.shrink();
                }
                final service = isLoading ? null : services[index];
                return GridViewServiceItem(
                  cardColor: cardColor,
                  cardImageColor: cardImageColor,
                  textColor: textColor,
                  service: service,
                );
              },
            ),
          ).paddingSymmetric(horizontal: 20.w);
        },
      );
    }
  }

class NoServiceFound extends StatelessWidget {
  const NoServiceFound({super.key});

  @override
  Widget build(BuildContext context) {
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
}
