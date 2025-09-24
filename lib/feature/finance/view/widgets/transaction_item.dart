
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, this.isReceived = true});
  final bool isReceived;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
              color: AppColors.secondaryColor,
            ),
            child: Icon(
              isReceived
                  ? Icons.arrow_downward_sharp
                  : Icons.arrow_upward_sharp,
              color: AppColors.primaryColor,
            ),
          ),
          12.pw,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isReceived?"Received Payment" : "Sent Payment",
                style: AppStyle.fontSize22BoldNewsReader.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              ),
              5.ph,
              Text(
                "2023-08-15",
                style: AppStyle.fontSize14RegularNewsReader.copyWith(
                  color: AppColors.descContainerColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            "+ \$5000.00",
            style: AppStyle.fontSize22BoldNewsReader.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    ).paddingSymmetric(horizontal: 16.w);
  }
}
