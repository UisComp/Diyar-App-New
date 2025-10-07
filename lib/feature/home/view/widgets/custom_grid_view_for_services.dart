import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:diyar_app/feature/home/view/widgets/grid_view_service_item.dart';
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
        final services = homeController.userServicesResponse.data ?? [];

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
              return GridViewServiceItem(
                cardColor: cardColor,
                cardImageColor: cardImageColor,
                textColor: textColor,
                index: index,
              );
            },
          ),
        ).paddingSymmetric(horizontal: 20.w);
      },
    );
  }
}
