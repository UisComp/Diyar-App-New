import 'dart:io';
import 'package:diyar_app/core/extension/padding.dart';
import 'package:diyar_app/core/extension/sized_box.dart';
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/style/app_style.dart';
import 'package:diyar_app/core/widgets/custom_app_bar.dart';
import 'package:diyar_app/core/widgets/custom_button.dart';
import 'package:diyar_app/core/widgets/custom_text_form_field.dart';
import 'package:diyar_app/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  File? image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleAppBar: LocaleKeys.personal_information.tr()),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  32.ph,
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50.r,
                          backgroundColor: AppColors.containerColor,
                          child: image != null
                              ? ClipOval(
                                  child: Image.file(
                                    image!,
                                    width: 100.r,
                                    height: 100.r,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 50.r,
                                  color: AppColors.primaryColor,
                                ),
                        ),
                        Positioned(
                          bottom: 5.h,
                          right: 5.w,
                          child: InkWell(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 10.r,
                              backgroundColor: AppColors.primaryColor,
                              child: Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(LocaleKeys.name.tr()).paddingSymmetric(horizontal: 16.w),
                  8.ph,
                  CustomTextFormField(
                    hintText: 'Eyad Mohamed',
                    hintStyle: AppStyle.fontSize14RegularNewsReader.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.descContainerColor,
                    ),
                  ),
                  24.ph,
                  Text(
                    LocaleKeys.email.tr(),
                    style: AppStyle.fontSize14RegularNewsReader.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ).paddingSymmetric(horizontal: 16.w),
                  8.ph,
                  CustomTextFormField(
                    hintText: 'eyadmohamed@gmail.com',
                    hintStyle: AppStyle.fontSize14RegularNewsReader.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.descContainerColor,
                    ),
                  ),
                  24.ph,
                  Text(
                    LocaleKeys.contact_mobile_number.tr(),
                  ).paddingSymmetric(horizontal: 16.w),
                  8.ph,
                  CustomTextFormField(
                    hintText: '+201010076119',
                    hintStyle: AppStyle.fontSize14RegularNewsReader.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.descContainerColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomButton(
            buttonColor: AppColors.primaryColor,
            buttonText: LocaleKeys.save_changes.tr(),
            onPressed: () {
              context.pop();
            },
          ).paddingSymmetric(horizontal: 16.w, vertical: 16.h),
        ],
      ),
    );
  }
}
