import 'package:diyar_app/core/style/app_color.dart';
import 'package:diyar_app/core/widgets/custom_cached_network_image.dart';
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
        final profileController = ProfileController.get(context);
        final profile = profileController.profileResponseModel.data;

        Widget imageWidget;

        if (profileController.image != null) {
          imageWidget = ClipOval(
            child: Image.file(
              profileController.image!,
              width: 100.r,
              height: 100.r,
              fit: BoxFit.cover,
            ),
          );
        } else if (profile?.profilePicture?.url != null) {
          imageWidget = ClipOval(
            child: CustomCachedNetworkImage(
              imageUrl: profile!.profilePicture!.url!,
              width: 100.r,
              height: 100.r,
              fit: BoxFit.cover,
            ),
          );
        } else {
          imageWidget = Icon(
            Icons.person,
            size: 50.r,
            color: AppColors.primaryColor,
          );
        }

        return Center(
          child: Stack(
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: AppColors.containerColor,
                child: imageWidget,
              ),

              // Edit button
              Positioned(
                bottom: 5.h,
                right: 5.w,
                child: InkWell(
                  onTap: () => _showPickImageSheet(context, profileController),
                  child: CircleAvatar(
                    radius: 14.r,
                    backgroundColor: AppColors.primaryColor,
                    child: const Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Shows camera / gallery picker options
  void _showPickImageSheet(BuildContext context, ProfileController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text("Pick from Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImage(fromCamera: false);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take a Photo"),
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImage(fromCamera: true);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
