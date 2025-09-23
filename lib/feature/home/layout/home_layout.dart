import 'package:diyar_app/core/constants/app_constants.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: AppConstants.screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.whiteColor,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              Assets.images.svg.settings,
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? AppColors.primaryColor : Colors.grey,
                BlendMode.srcIn,
              ),
              height: 24,
              width: 24,
            ),
            label: LocaleKeys.settings.tr(),
          ),
          BottomNavigationBarItem(
            icon:  SvgPicture.asset(
              Assets.images.svg.home,
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? AppColors.primaryColor : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: LocaleKeys.home.tr(),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              Assets.images.svg.person,
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? AppColors.primaryColor : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            label: LocaleKeys.profile.tr(),
          ),
        ],
      ),
    );
  }
}
