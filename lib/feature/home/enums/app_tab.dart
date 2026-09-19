import 'package:diyar_app/feature/finance/view/finance_screen.dart';
import 'package:diyar_app/feature/home/view/home_screen.dart';
import 'package:diyar_app/feature/profile/view/profile_screen.dart';
import 'package:diyar_app/feature/settings/view/settings_screen.dart';
import 'package:diyar_app/gen/assets.gen.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:flutter/widgets.dart';

/// The bottom navigation tabs, in display order.
///
/// Tabs are addressed by identity rather than position because Finance is
/// hidden for guests and guards, which would otherwise shift every index
/// after it.
enum AppTab {
  home,
  finance,
  profile,
  settings;

  /// Tabs the current user can see.
  static List<AppTab> get visible => [
    for (final tab in values)
      if (tab != AppTab.finance || canAccessFinance) tab,
  ];

  String get labelKey => switch (this) {
    AppTab.home => LocaleKeys.home,
    AppTab.finance => LocaleKeys.finance,
    AppTab.profile => LocaleKeys.profile,
    AppTab.settings => LocaleKeys.settings,
  };

  String get iconAsset => switch (this) {
    AppTab.home => Assets.images.svg.home,
    AppTab.finance => Assets.images.svg.finance,
    AppTab.profile => Assets.images.svg.person,
    AppTab.settings => Assets.images.svg.settings,
  };

  Widget get screen => switch (this) {
    AppTab.home => const HomeScreen(),
    AppTab.finance => const FinanceScreen(),
    AppTab.profile => const ProfileScreen(),
    AppTab.settings => const SettingsScreen(),
  };
}
