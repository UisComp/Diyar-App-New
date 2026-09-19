import 'package:diyar_app/core/cubits/language/language_controller.dart';
import 'package:diyar_app/core/cubits/language/language_state.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/controller/home_state.dart';
import 'package:diyar_app/feature/home/enums/app_tab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late final HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = HomeController.get(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeController,
      child: BlocBuilder<HomeController, HomeState>(
        buildWhen: (_, current) => current is ChangeIndexBottomNavBarState,
        builder: (context, homeState) {
          final tabs = AppTab.visible;
          // A tab can disappear (e.g. Finance after the role changes), so fall
          // back to Home instead of pointing past the end of the list.
          final selected = tabs.contains(_homeController.currentTab)
              ? tabs.indexOf(_homeController.currentTab)
              : 0;

          return Scaffold(
            body: SafeArea(
              bottom: false,
              child: IndexedStack(
                index: selected,
                children: [for (final tab in tabs) tab.screen],
              ),
            ),
            bottomNavigationBar: BlocBuilder<LanguageController, LanguageState>(
              builder: (context, _) => _BottomNavBar(
                tabs: tabs,
                selectedIndex: selected,
                onSelected: (index) => _homeController.changeTab(tabs[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<AppTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final unselected = surface.textSecondary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: surface.card,
        border: Border(top: BorderSide(color: surface.border)),
        boxShadow: surface.isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.blackColor.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: surface.card,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          height: 64.h,
          indicatorColor: AppColors.primaryColor.withValues(alpha: 0.12),
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          labelTextStyle: WidgetStateProperty.resolveWith(
            (states) => TextStyle(
              fontSize: 11.5.sp,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: states.contains(WidgetState.selected)
                  ? AppColors.primaryColor
                  : unselected,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onSelected,
          animationDuration: const Duration(milliseconds: 350),
          destinations: [
            for (final tab in tabs)
              NavigationDestination(
                icon: _icon(tab.iconAsset, unselected),
                selectedIcon: _icon(tab.iconAsset, AppColors.primaryColor),
                label: tab.labelKey.tr(),
                tooltip: '',
              ),
          ],
        ),
      ),
    );
  }

  Widget _icon(String asset, Color color) => SvgPicture.asset(
    asset,
    height: 22.r,
    width: 22.r,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
  );
}
