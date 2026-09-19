import 'package:diyar_app/core/widgets/empty_state_view.dart';
import 'package:diyar_app/feature/home/controller/home_controller.dart';
import 'package:diyar_app/feature/home/view/widgets/grid_view_service_item.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Services grid on Home. Covers every state of the section: loading
/// skeleton, load error with retry, no services, no search matches, and data.
class CustomGridViewForServices extends StatelessWidget {
  const CustomGridViewForServices({
    super.key,
    required this.cardColor,
    required this.cardImageColor,
    required this.textColor,
    this.maxItems,
  });

  final Color cardColor;
  final Color cardImageColor;
  final Color textColor;

  /// Caps the number of cards; null shows all (used for search results).
  final int? maxItems;

  static const _crossAxisCount = 3;

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.get(context);
    final isSearching = controller.searchController.text.trim().isNotEmpty;
    final services = controller.homeServices;

    final Widget child;
    if (controller.isServicesLoading) {
      child = Skeletonizer(
        key: const ValueKey('loading'),
        child: _grid(List.filled(_crossAxisCount, null)),
      );
    } else if (controller.servicesFailed && services.isEmpty) {
      child = EmptyStateView.error(
        key: const ValueKey('error'),
        message: LocaleKeys.services_load_failed.tr(),
        onRetry: controller.getAllServices,
      );
    } else if (services.isEmpty) {
      child = EmptyStateView(
        key: ValueKey('empty-$isSearching'),
        title: isSearching
            ? LocaleKeys.no_results_found
            : LocaleKeys.no_services_available_for_you,
        message: isSearching
            ? LocaleKeys.no_results_desc.tr()
            : LocaleKeys.no_services_desc.tr(),
        icon: isSearching ? Icons.search_off_rounded : null,
      );
    } else {
      final visible = maxItems == null
          ? services
          : services.take(maxItems!).toList();
      child = KeyedSubtree(key: const ValueKey('data'), child: _grid(visible));
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
    );
  }

  Widget _grid(List<dynamic> services) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) => GridViewServiceItem(
        cardColor: cardColor,
        cardImageColor: cardImageColor,
        textColor: textColor,
        service: services[index],
        compact: true,
      ),
    );
  }
}
