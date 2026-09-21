import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/relative_date.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/feature/news/controller/news_controller.dart';
import 'package:diyar_app/feature/news/controller/news_state.dart';
import 'package:diyar_app/feature/news/model/news_details_response_model.dart';
import 'package:diyar_app/feature/news/view/widgets/carousel_image_silder.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
          final news = newsController.newsDetailsResponseModel.data;
          final hasMedia = news?.media?.isNotEmpty ?? false;

          return Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
              child: Column(
                // Full width, so the title and the article line up on their
                // own language's side whatever the app's language is.
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isLoading)
                    AspectRatio(
                      aspectRatio: CarouselImageSilder.aspectRatio,
                      child: Bone(borderRadius: BorderRadius.circular(16.r)),
                    )
                  else if (hasMedia)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: CarouselImageSilder(
                        newsDetails: news,
                        newsController: newsController,
                      ),
                    ),
                  20.ph,
                  if (isLoading)
                    const _ArticleSkeleton()
                  else if (news != null)
                    _Article(news: news),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Article extends StatelessWidget {
  const _Article({required this.news});

  final NewsDataDetails news;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final locale = context.locale.languageCode;
    final longDate = RelativeDate.longDate(news.newsDate, locale: locale);
    final ago = RelativeDate.format(
      news.newsDate,
      locale: locale,
      orDate: false,
    );
    final tags = [
      if (news.project?.name case final String name when name.isNotEmpty)
        (Icons.apartment_rounded, name),
      if (news.unit?.name case final String name when name.isNotEmpty)
        (Icons.home_work_outlined, name),
    ];
    final title = news.title?.trim() ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (tags.isNotEmpty) ...[
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final (icon, label) in tags) _Tag(icon: icon, label: label),
            ],
          ),
          14.ph,
        ],
        if (title.isNotEmpty)
          AppText(
            title,
            style: AppStyle.fontSize22BoldNewsReader(
              context,
            ).copyWith(fontSize: 24.sp, height: 1.35),
          ),
        if (longDate != null) ...[
          10.ph,
          // The app's own words, so they follow the app's direction.
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14.sp,
                color: surface.textSecondary,
              ),
              6.pw,
              Flexible(
                child: Text(
                  [longDate, if (ago != null) ago].join('  ·  '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.fontSize12Regular(
                    context,
                  ).copyWith(color: surface.textSecondary, fontSize: 13.sp),
                ),
              ),
            ],
          ),
        ],
        20.ph,
        Divider(height: 1, thickness: 1, color: surface.border),
        20.ph,
        SelectionArea(child: _ArticleBody(content: news.content ?? '')),
      ],
    );
  }
}

/// The article, one paragraph at a time: each reads in its own language's
/// direction, so an English paragraph in an Arabic article (or the
/// reverse) is laid out on its own side.
class _ArticleBody extends StatelessWidget {
  const _ArticleBody({required this.content});

  final String content;

  static final _lineBreaks = RegExp(r'\r?\n');

  @override
  Widget build(BuildContext context) {
    final paragraphs = [
      for (final line in content.split(_lineBreaks))
        if (line.trim().isNotEmpty) line.trim(),
    ];
    final style = AppStyle.fontSize14RegularNewsReader(context).copyWith(
      fontSize: 16.sp,
      height: 1.75,
      color: AppSurface.of(context).textPrimary.withValues(alpha: 0.82),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < paragraphs.length; i++) ...[
          if (i > 0) 14.ph,
          AppText(paragraphs[i], style: style),
        ],
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.primaryColor),
          5.pw,
          Flexible(
            child: AppText(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.fontSize12Bold(
                context,
              ).copyWith(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleSkeleton extends StatelessWidget {
  const _ArticleSkeleton();

  @override
  Widget build(BuildContext context) {
    Widget line(double widthFactor, double height) => FractionallySizedBox(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: widthFactor,
      child: Bone(height: height, borderRadius: BorderRadius.circular(6.r)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        line(0.35, 22.h),
        14.ph,
        line(0.9, 24.h),
        8.ph,
        line(0.6, 24.h),
        12.ph,
        line(0.4, 12.h),
        24.ph,
        for (var i = 0; i < 6; i++) ...[line(i == 5 ? 0.55 : 1, 14.h), 10.ph],
      ],
    );
  }
}
