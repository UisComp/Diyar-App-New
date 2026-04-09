import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
import 'package:diyar_app/feature/profile/controller/profile_controller.dart';
import 'package:diyar_app/feature/profile/controller/profile_state.dart';
import 'package:diyar_app/feature/profile/model/user_units_response_model.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LinkedUnitsDetailScreen extends StatefulWidget {
  final UserUnit unitData;

  const LinkedUnitsDetailScreen({super.key, required this.unitData});

  @override
  State<LinkedUnitsDetailScreen> createState() =>
      _LinkedUnitsDetailScreenState();
}

class _LinkedUnitsDetailScreenState extends State<LinkedUnitsDetailScreen> {
  late final ProfileController profileController;
  @override
  void initState() {
    super.initState();
    profileController = ProfileController.get(context);
    fetchUnitDetails();
  }

  Future<void> fetchUnitDetails() async {
    await profileController.getUnitsForUserLinkedUnits(
      id: widget.unitData.id.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileController, ProfileState>(
      builder: (context, state) {
        final unitData =
            profileController.unitModelDetailsForLinkedUserResponseModel.data;
        final isLoading = state is GetUnitsForUserLinkedLoadingState;

        return Scaffold(
          appBar: CustomAppBar(
            titleAppBar: unitData?.name ?? LocaleKeys.unit_details.tr(),
            centerTitle: true,
          ),
          body: Skeletonizer(
            enabled: isLoading,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (profileController
                          .unitModelDetailsForLinkedUserResponseModel
                          .data
                          ?.mainImage !=
                      null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      // child: CachedImage(
                      //   url:
                      //       profileController
                      //           .unitModelDetailsForLinkedUserResponseModel
                      //           .data
                      //           ?.mainImage!
                      //           .url ??
                      //       '',
                      //   width: double.infinity,
                      //   height: 200.h,
                      //   fit: BoxFit.cover,
                      // ),
                      child: CustomCachedNetworkImage(
                        imageUrl:
                            profileController
                                .unitModelDetailsForLinkedUserResponseModel
                                .data
                                ?.mainImage
                                ?.url ??
                            '',
                        width: double.infinity,
                        height: 200.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  16.ph,
                  AppText(
                    unitData?.name ?? '',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  12.ph,
                  AppText(
                    "${LocaleKeys.building.tr()} ${unitData?.building ?? LocaleKeys.un_defined.tr()}",
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
                  ),
                  AppText(
                    "${LocaleKeys.number.tr()} ${unitData?.number ?? LocaleKeys.un_defined.tr()}",
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
                  ),
                  20.ph,
                  AppText(
                    LocaleKeys.news.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  12.ph,
                  if (unitData?.news?.isNotEmpty ?? false)
                    Column(
                      children: (unitData?.news ?? []).map((newsItem) {
                        return Card(
                          color: AppColors.whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          margin: EdgeInsets.only(bottom: 16.h),
                          elevation: 3,
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (newsItem.media != null &&
                                      newsItem.media!.isNotEmpty)
                                    SizedBox(
                                      height: 100.h,
                                      width: 120.w,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: newsItem.media!.length,
                                        itemBuilder: (context, index) {
                                          final media = newsItem.media![index];
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              right: 8.w,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              child: CustomCachedNetworkImage(
                                                imageUrl: media.url ?? '',
                                                width: 100.w,
                                                height: 100.h,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  8.pw,
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          newsItem.title ?? '',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        8.ph,
                                        AppText(
                                          newsItem.content ?? '',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  else
                    Center(
                      child: AppText(
                        LocaleKeys.no_news_found.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
