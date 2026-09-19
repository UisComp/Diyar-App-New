import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/formatter/phone_formatter.dart';
import 'package:diyar_app/core/functions/api_error_message.dart';
import 'package:diyar_app/core/functions/app_functions.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/style/app_surface.dart';
import 'package:diyar_app/core/widgets/app_text.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/empty_state_view.dart';
import 'package:diyar_app/feature/auth/model/user_phone.dart';
import 'package:diyar_app/feature/auth/view/widgets/auth_widgets.dart';
import 'package:diyar_app/feature/phone_numbers/controller/phone_numbers_controller.dart';
import 'package:diyar_app/feature/phone_numbers/controller/phone_numbers_state.dart';
import 'package:diyar_app/feature/phone_numbers/model/phone_numbers_models.dart';
import 'package:diyar_app/feature/phone_numbers/view/widgets/phone_request_sheet.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The numbers the resident signs in with, and their change requests.
class PhoneNumbersScreen extends StatelessWidget {
  const PhoneNumbersScreen({super.key});

  void _onState(BuildContext context, PhoneNumbersState state) {
    if (state is PhoneNumbersActionSuccessState) {
      AppFunctions.successMessage(
        context,
        message: switch (state.action) {
          PhoneNumbersAction.madePrimary =>
            LocaleKeys.primary_number_updated.tr(),
          PhoneNumbersAction.removalRequested =>
            LocaleKeys.phone_request_sent.tr(),
          PhoneNumbersAction.requestCancelled =>
            LocaleKeys.phone_request_cancelled.tr(),
        },
      );
    }
    if (state is PhoneNumbersActionFailureState) {
      AppFunctions.errorMessage(
        context,
        message: apiErrorMessage(state.result),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.phone_numbers.tr()),
      body: SafeArea(
        child: BlocConsumer<PhoneNumbersController, PhoneNumbersState>(
          listener: _onState,
          builder: (context, state) {
            final controller = PhoneNumbersController.get(context);
            if (controller.isFirstLoad) {
              if (state is PhoneNumbersLoadFailureState) {
                return Center(
                  child: EmptyStateView.error(
                    message:
                        '${LocaleKeys.phone_numbers_load_failed.tr()}\n'
                        '${apiErrorMessage(state.result)}',
                    onRetry: controller.load,
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }
            return _PhoneNumbersBody(
              overview: controller.overview,
              busy:
                  state is PhoneNumbersActionLoadingState ||
                  state is PhoneNumbersLoadingState,
            );
          },
        ),
      ),
    );
  }
}

class _PhoneNumbersBody extends StatelessWidget {
  const _PhoneNumbersBody({required this.overview, required this.busy});

  final PhoneNumbersOverview overview;
  final bool busy;

  Future<void> _openRequestSheet(
    BuildContext context, {
    UserPhone? replaced,
  }) async {
    final controller = PhoneNumbersController.get(context);
    final sent = await PhoneRequestSheet.show(
      context,
      replacedPhoneId: replaced?.id,
      replacedPhone: replaced?.phone,
    );
    if (sent == true && context.mounted) {
      AppFunctions.successMessage(
        context,
        message: LocaleKeys.phone_request_sent.tr(),
      );
      await controller.load();
    }
  }

  Future<void> _confirmRemove(BuildContext context, UserPhone phone) {
    return showAuthActionDialog(
      context,
      title: LocaleKeys.remove_number.tr(),
      message: LocaleKeys.remove_number_confirm.tr(
        args: [displayPhone(phone.phone)],
      ),
      actionText: LocaleKeys.confirm.tr(),
      onAction: () =>
          PhoneNumbersController.get(context).requestRemoval(phone.id),
    );
  }

  Future<void> _confirmCancel(BuildContext context, PhoneChangeRequest r) {
    return showAuthActionDialog(
      context,
      title: LocaleKeys.cancel_request.tr(),
      message: LocaleKeys.cancel_request_confirm.tr(),
      actionText: LocaleKeys.confirm.tr(),
      onAction: () => PhoneNumbersController.get(context).cancelRequest(r.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = PhoneNumbersController.get(context);
    final surface = AppSurface.of(context);
    return RefreshIndicator(
      onRefresh: controller.load,
      child: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          if (busy) ...[const LinearProgressIndicator(), 12.ph],
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
                10.pw,
                Expanded(
                  child: AppText(
                    LocaleKeys.phone_numbers_hint.tr(),
                    style: AppStyle.fontSize12Regular(
                      context,
                    ).copyWith(color: surface.textPrimary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          20.ph,
          for (final phone in overview.phones) ...[
            _PhoneTile(
              phone: phone,
              enabled: !busy,
              locked: overview.hasPendingRequestFor(phone.phone),
              canRemove: overview.canRemove,
              canRequest: overview.canRequestMore,
              onMakePrimary: () => controller.makePrimary(phone.id),
              onReplace: () => _openRequestSheet(context, replaced: phone),
              onRemove: () => _confirmRemove(context, phone),
            ),
            10.ph,
          ],
          8.ph,
          CustomButton(
            buttonHeight: 50.h,
            buttonText: LocaleKeys.add_number.tr(),
            buttonColor: overview.canRequestMore && !busy
                ? AppColors.primaryColor
                : AppColors.greyColor,
            onPressed: busy
                ? null
                : () {
                    if (!overview.canRequestMore) {
                      AppFunctions.warningMessage(
                        context,
                        message: LocaleKeys.requests_limit_reached.tr(
                          args: ['${overview.maxPendingRequests}'],
                        ),
                      );
                      return;
                    }
                    _openRequestSheet(context);
                  },
          ),
          if (overview.requests.isNotEmpty) ...[
            28.ph,
            AppText(
              LocaleKeys.phone_requests.tr(),
              style: AppStyle.fontSize16Bold(context),
            ),
            10.ph,
            for (final request in overview.requests) ...[
              _RequestTile(
                request: request,
                onCancel: request.isPending && !busy
                    ? () => _confirmCancel(context, request)
                    : null,
              ),
              10.ph,
            ],
          ],
        ],
      ),
    );
  }
}

class _PhoneTile extends StatelessWidget {
  const _PhoneTile({
    required this.phone,
    required this.enabled,
    required this.locked,
    required this.canRemove,
    required this.canRequest,
    required this.onMakePrimary,
    required this.onReplace,
    required this.onRemove,
  });

  final UserPhone phone;
  final bool enabled;

  /// A request for this number is waiting: no new one until it's reviewed.
  final bool locked;
  final bool canRemove;
  final bool canRequest;
  final VoidCallback onMakePrimary;
  final VoidCallback onReplace;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final actions = <(String, IconData, VoidCallback)>[
      if (!phone.isPrimary)
        (
          LocaleKeys.make_primary.tr(),
          Icons.star_outline_rounded,
          onMakePrimary,
        ),
      if (!locked && canRequest)
        (LocaleKeys.replace_number.tr(), Icons.swap_horiz_rounded, onReplace),
      if (!locked && canRequest && canRemove)
        (LocaleKeys.remove_number.tr(), Icons.delete_outline_rounded, onRemove),
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: surface.cardDecoration(
        radius: 14.r,
        borderColor: phone.isPrimary
            ? AppColors.primaryColor.withValues(alpha: 0.4)
            : null,
      ),
      child: Row(
        children: [
          Icon(
            Icons.phone_iphone_rounded,
            color: phone.isPrimary
                ? AppColors.primaryColor
                : surface.textSecondary,
          ),
          12.pw,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayPhone(phone.phone),
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: surface.textPrimary,
                  ),
                ),
                if (phone.isPrimary || !phone.verified) ...[
                  4.ph,
                  Wrap(
                    spacing: 6.w,
                    children: [
                      if (phone.isPrimary)
                        _Badge(
                          text: LocaleKeys.primary.tr(),
                          color: AppColors.primaryColor,
                        ),
                      if (!phone.verified)
                        _Badge(
                          text: LocaleKeys.not_used_yet.tr(),
                          color: AppColors.greyColor,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (actions.isNotEmpty)
            PopupMenuButton<VoidCallback>(
              enabled: enabled,
              icon: const Icon(Icons.more_vert_rounded),
              onSelected: (action) => action(),
              itemBuilder: (_) => [
                for (final (label, icon, action) in actions)
                  PopupMenuItem(
                    value: action,
                    child: Row(
                      children: [
                        Icon(icon, size: 20.sp),
                        10.pw,
                        Text(label),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({required this.request, this.onCancel});

  final PhoneChangeRequest request;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final surface = AppSurface.of(context);
    final (statusText, statusColor) = switch (request.status) {
      PhoneChangeStatus.pending => (
        LocaleKeys.pending.tr(),
        AppColors.orangeColor,
      ),
      PhoneChangeStatus.approved => (
        LocaleKeys.status_approved.tr(),
        AppColors.greenColor,
      ),
      PhoneChangeStatus.rejected => (
        LocaleKeys.status_rejected.tr(),
        AppColors.redColor,
      ),
      PhoneChangeStatus.cancelled => (
        LocaleKeys.cancelled.tr(),
        AppColors.greyColor,
      ),
    };
    final title = switch (request.type) {
      PhoneChangeType.add => LocaleKeys.request_type_add.tr(),
      PhoneChangeType.replace => LocaleKeys.request_type_replace.tr(),
      PhoneChangeType.remove => LocaleKeys.request_type_remove.tr(),
    };
    final numbers = [
      if (request.oldPhone != null) displayPhone(request.oldPhone!),
      if (request.newPhone != null) displayPhone(request.newPhone!),
    ].join('  →  ');
    final date = request.createdAt;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: surface.cardDecoration(radius: 14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(title, style: AppStyle.fontSize14Bold(context)),
              ),
              _Badge(text: statusText, color: statusColor),
            ],
          ),
          if (numbers.isNotEmpty) ...[
            6.ph,
            Text(
              numbers,
              textDirection: TextDirection.ltr,
              style: TextStyle(fontSize: 13.sp, color: surface.textPrimary),
            ),
          ],
          if (date != null) ...[
            4.ph,
            AppText(
              DateFormat.yMMMd(
                context.locale.toString(),
              ).add_jm().format(date.toLocal()),
              style: TextStyle(fontSize: 12.sp, color: surface.textSecondary),
            ),
          ],
          if (request.status == PhoneChangeStatus.rejected &&
              (request.rejectionReason?.isNotEmpty ?? false)) ...[
            6.ph,
            AppText(
              LocaleKeys.rejection_reason.tr(args: [request.rejectionReason!]),
              style: TextStyle(fontSize: 12.5.sp, color: AppColors.redColor),
            ),
          ],
          if (onCancel != null)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: onCancel,
                child: Text(
                  LocaleKeys.cancel_request.tr(),
                  style: const TextStyle(color: AppColors.redColor),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
