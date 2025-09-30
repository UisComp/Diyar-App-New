import 'dart:developer';
import 'dart:io';

import 'package:diyar_app/core/model/request_model.dart';
import 'package:diyar_app/feature/profile/controller/profile_state.dart';
import 'package:diyar_app/feature/profile/model/profile_response_model.dart';
import 'package:diyar_app/feature/profile/service/profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends Cubit<ProfileState> {
  ProfileController() : super(ProfileInitialState());
  static ProfileController get(BuildContext context) =>
      BlocProvider.of(context);
  ProfileResponseModel profileResponseModel = ProfileResponseModel();
  ProfileResponseModel editProfileResponseModel = ProfileResponseModel();
  final TextEditingController emailProfileController = TextEditingController();
  final TextEditingController nameProfileController = TextEditingController();
  Future<void> getMyProfile() async {
    emit(GetMyProfileLoadingState());
    await ProfileService.getProfile()
        .then((value) {
          profileResponseModel = value;
          emit(GetMyProfileSuccessState());
        })
        .catchError((error) {
          log('Error Happen While Get My Profile is $error');
          emit(GetMyProfileFailureState());
        });
  }

  File? image;
  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        image = File(pickedFile.path);
        emit(PickingImageProfileSuccessfully());
      } else {
        emit(EmptyImageProfileState());
      }
    } catch (e, stack) {
      log('Error Happen While Picking Image $e\n$stack');
      emit(PickingImageProfileFailureState(error: e.toString()));
    }
  }

  Future<void> editProfile() async {
    emit(EditingProfileLoadingState());
    await ProfileService.editProfile(
          authRequestModel: RequestModel(
            email: emailProfileController.text,
            name: nameProfileController.text,
          ),
        )
        .then((value) {
          profileResponseModel = value;
          emit(EditingProfileSuccessfullyState());
        })
        .catchError((error) {
          log('Error Happen While Editing My Profile is $error');
          emit(EditingProfileFailureState());
        });
  }
}
