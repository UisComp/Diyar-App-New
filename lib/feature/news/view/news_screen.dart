import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/routes/routes_name.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/news/controller/news_controller.dart';
import 'package:diyar_app/feature/news/controller/news_state.dart';
import 'package:diyar_app/feature/settings/view/widgets/custom_container_information.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
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
          final isLoading = state is GetAllNewsLoadingState;
          final newsList = newsController.newsResponseModel.data ?? [];

          // 🟡 حالة لا يوجد بيانات بعد التحميل
          if (!isLoading && newsList.isEmpty) {
            return Center(
              child: Text(
                LocaleKeys.no_news_found.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          return Skeletonizer(
            enabled: isLoading,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index) => 10.ph,
              itemCount: isLoading ? 5 : newsList.length,
              itemBuilder: (context, index) {
                final item = isLoading ? null : newsList[index];

                return CustomContainerInformation(
                  projectName: item?.project?.name,
                  onTap: () {
                    if (!isLoading && item?.project?.id != null) {
                      context.push(
                        RoutesName.projectDetails,
                        extra: item!.project!.id.toString(),
                      );
                    }
                  },
                  descriptionContainer: item?.content ?? "2 days ago",
                  titleContainer: item?.title ?? "Loading...",
                  imageUrl: item?.media?[0].url,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
