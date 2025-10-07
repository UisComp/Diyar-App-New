import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/news/controller/news_controller.dart';
import 'package:diyar_app/feature/news/controller/news_state.dart';
import 'package:diyar_app/feature/news/view/widgets/carousel_image_silder.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsDetailsScreen extends StatefulWidget {
  const NewsDetailsScreen({super.key});

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  late NewsController newsController;

  @override
  void initState() {
    super.initState();
    newsController = NewsController.get(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.news.tr()),
      body: BlocBuilder<NewsController, NewsState>(
        builder: (context, state) {
          final isLoading = state is GetNewsDetailsLoadingState;
          final newsDetails = newsController.newsDetailsResponseModel.data;
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (newsDetails == null) {
            return Center(child: Text(LocaleKeys.no_details_found.tr()));
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (newsDetails.media != null && newsDetails.media!.isNotEmpty)
                  CarouselImageSilder(
                    newsDetails: newsDetails,
                    newsController: newsController,
                  ),
                30.ph,
                Text(
                  newsDetails.title ?? '',
                  style: AppStyle.fontSize22Bold(context),
                ),
                10.ph,
                Text(
                  newsDetails.newsDate?.substring(0, 10) ?? '',
                  style: AppStyle.fontSize14RegularNewsReader(
                    context,
                  ).copyWith(color: AppColors.descContainerColor),
                ),
                16.ph,
                Text(
                  newsDetails.content ?? '',
                  style: AppStyle.fontSize14RegularNewsReader(
                    context,
                  ).copyWith(fontSize: 16.sp),
                ),
              ],
            ).paddingSymmetric(horizontal: 16.w),
          );
        },
      ),
    );
  }
}