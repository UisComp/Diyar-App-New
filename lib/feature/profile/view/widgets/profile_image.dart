
import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/feature/profile/controller/profile_controller.dart';
import 'package:diyar_app/feature/profile/controller/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileController, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        final ProfileController profileController = ProfileController.get(
          context,
        );
        return Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: AppColors.containerColor,
                child: profileController.image != null
                    ? ClipOval(
                        child: Image.file(
                          profileController.image!,
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
                  onTap: profileController.pickImage,
                  child: CircleAvatar(
                    radius: 10.r,
                    backgroundColor: AppColors.primaryColor,
                    child: Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
