import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/feature/internet/controller/internet_controller.dart';
import 'package:diyar_app/feature/internet/controller/internet_state.dart';
import 'package:diyar_app/feature/internet/service/internet_service.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class NoInternetConnection extends StatelessWidget {
  const NoInternetConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: InternetConnectivityService.currentStatus,
      onPopInvokedWithResult: (didPop, result) {},
      child:
          BlocBuilder<InternetConnectionController, InternetConnectionStates>(
            builder: (context, state) {
              return Scaffold(
                resizeToAvoidBottomInset: true,
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 30,
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 1.sw,
                            height: 0.5.sh,
                            child:Lottie.asset(Assets.images.noInternet,repeat: true),
                          ),
                          SizedBox(height: 0.02.sh),
                          Text(
                            LocaleKeys.no_internet.tr(),
                            style: AppStyle.fontSize22Bold(context).copyWith(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 0.02.sh),
                          Text(
                            LocaleKeys.please_check_your_internet_connection
                                .tr(),
                            style: AppStyle.fontSize16Regular(context).copyWith(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          40.ph,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }
}
